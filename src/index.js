require('dotenv').config();
const express = require('express');
const multer = require('multer');
const upload = multer({dest:"tmp_uploads/"});
const fs = require('fs');
const {v4:uuidv4} = require('uuid');
const app = express(); 
const session = require('express-session');
const db = require(__dirname+'/db_connect');
const bcrypt = require('bcryptjs');

app.set('view engine', 'ejs'); 

// 建立session
app.use(session({
    saveUninitialized: false,       //建立時是否先建立空檔案
    resave: false,
    secret: 'yioepwlpxx45hhhtrek7',
    cookie: {
        maxAge: 1200000,        //單位: ms
    }
}));



// ======= initial middleware =======
app.use(express.urlencoded({extended: false}));   //setup middleware;   body-parser
app.use(express.json())

app.use(express.static(__dirname+'/../public'));

app.use((req, res, next)=>{
    res.locals.title = 'Mini Project';       //res.locals.變數  可以傳入變數 = render('template', {變數})
    res.locals.session = req.session;
    next();
});
app.use(require('cors')());
// ======= initial middleware ends =======


app.get('/',(req, res)=>{
    res.render('home');
});

// ==== market ====
app.get('/item-list',(req, res)=>{
    res.render('items');
});
app.get('/item-list-api/:page', async (req, res)=>{
    const perPage = 8; // 每頁有幾筆
    let page = req.params.page ? parseInt(req.params.page) : 1;

    // 算總筆數
    const [r1] = await db.query("SELECT COUNT(1) num FROM `items` WHERE `onsale` != 0");
    const totalRows = r1[0]['num'];

    // 算總頁數
    const totalPages = Math.ceil(totalRows/perPage);
    let rows = [];

    if(totalRows>0){
        if(page<1) page=1;
        if(page>totalPages) page=totalPages;

        const sql = `SELECT * FROM items WHERE onsale != 0 ORDER BY sid DESC LIMIT ${(page-1)*perPage}, ${perPage} `;
        [rows] = await db.query(sql);
        // rows.forEach(el=>{
        //     el.birthday = moment(el.birthday).format('YYYY-MM-DD');
        // });
    }

    res.json( {
        totalRows,
        totalPages,
        perPage,
        page,
        rows,
    });
});
app.get('/item-list-api4follow/:page', async (req, res)=>{
    const perPage = 8; // 每頁有幾筆
    let page = req.params.page ? parseInt(req.params.page) : 1;

    // 算總筆數
    const sql0 = `SELECT COUNT(1) num FROM follow WHERE pid = ${req.session.admin.pid}`
    const [r1] = await db.query(sql0);
    const totalRows = r1[0]['num'];

    // 算總頁數
    const totalPages = Math.ceil(totalRows/perPage);
    let rows = [];

    if(totalRows>0){
        if(page<1) page=1;
        if(page>totalPages) page=totalPages;

        const sql = `SELECT i.name, f.item_id, i.price, i.owner FROM follow f, items i WHERE pid = ${req.session.admin.pid} AND f.item_id = i.item_id LIMIT ${(page-1)*perPage}, ${perPage} `;
        [rows] = await db.query(sql);
    }

    res.json( {
        totalRows,
        totalPages,
        perPage,
        page,
        rows,
    });
});
app.get('/item-list-api4depo/:page', async (req, res)=>{
    const perPage = 8; // 每頁有幾筆
    let page = req.params.page ? parseInt(req.params.page) : 1;

    // 算總筆數
    // console.log(req.session.admin.account);
    // let name = req.session.admin.account;
    // const sql1 = "SELECT COUNT(1) num FROM items WHERE owner=? and onsale=?";
    // const [r1] = await db.query(sql1, [name, 0]);
    const sql0 = `SELECT COUNT(1) num FROM items WHERE \`owner\` = '${req.session.admin.account}' AND \`onsale\` = 0`
    const [r1] = await db.query(sql0);
    const totalRows = r1[0]['num'];

    // 算總頁數
    const totalPages = Math.ceil(totalRows/perPage);
    let rows = [];

    if(totalRows>0){
        if(page<1) page=1;
        if(page>totalPages) page=totalPages;

        const sql = `SELECT * FROM items WHERE owner='${req.session.admin.account}' AND onsale=0 ORDER BY sid DESC LIMIT ${(page-1)*perPage}, ${perPage} `;
        [rows] = await db.query(sql);
    }

    res.json( {
        totalRows,
        totalPages,
        perPage,
        page,
        rows,
    });
});
app.post('/item-list-follow', async (req, res)=>{
    const output = {
        success: false,
        error: '',
        code: 0,
        flip: false,
    };
    if(!req.session.admin) {
        output.code = 405;      // 亂設
        output.error = '請先登入, 即將跳轉';
        return res.json(output);
    }else{
    // output.postData = req.body;   // 丟回 client 以方便除錯

    let itemid = req.body.itemid;
    if(itemid.length < 2){
        output.error = 'item id too short';
        return res.json(output);
    }
    const tsql = "SELECT * FROM follow WHERE pid=? and item_id=?";
    const [rs0] = await db.query(tsql, [req.session.admin.pid, itemid]);
    if(rs0.length){
        const dsql = "DELETE FROM `follow` WHERE `sid`=?";
        await db.query(dsql, [rs0[0].sid]);
        output.success = true;
        // res.json(output);
        return res.json(output);
    }

    const sql = `INSERT INTO \`follow\` 
                (\`pid\`, \`item_id\`)
                 VALUES (?, ?)`;

    const [result] = await db.query(sql, [req.session.admin.pid, itemid]);

    output.result = result;
    output.flip = true;
    if(result.affectedRows){
        output.success = true;
    }
    res.json(output);
    }
});
app.post('/item-list-buy', async (req, res)=>{
    const output = {
        success: false,
        error: '',
        code: 0,
    };
    if(!req.session.admin) {
        output.code = 405;      // 亂設
        output.error = '請先登入, 即將跳轉';
        return res.json(output);
    }else{
    // output.postData = req.body;   // 丟回 client 以方便除錯

    let itemid = req.body.itemid;
    if(itemid.length < 2){
        output.error = 'item id too short';
        return res.json(output);
    }else if(itemid=='SW01'||itemid=='SW02'||itemid=='SW03'){
        // TODO
    }
    const tsql = "SELECT * FROM items WHERE item_id=?";
    const [rs0] = await db.query(tsql, [itemid]);
    if(!rs0.length){
        output.error = '找不到該商品，請重新整理頁面';
        return res.json(output);
    }else if(req.session.admin.coin<rs0[0].price){
        output.code = 430;
        output.error = '錢包金額不足';
        return res.json(output);
    }
    let own = rs0[0].owner;
    let price = rs0[0].price;
    const sql1 = "SELECT * FROM member WHERE account=?";
    const [rs1] = await db.query(sql1, [own]);
    if(!rs0.length){
        output.error = '找不到擁有者';
        return res.json(output);
    }
    ownid = rs1[0].pid;
    let tax = Math.floor(price/10);

    const sql = `INSERT INTO \`transaction\` 
                (\`item_id\`, \`seller_id\`, \`buyer_id\`,\`price\`,\`tax\`)
                 VALUES (?, ?, ?, ?, ?)`;

    const [result] = await db.query(sql, [itemid, ownid, req.session.admin.pid, price, tax]);

    output.result = result;
    if(result.affectedRows){
        const Usql = `UPDATE \`items\` SET \`owner\`=?, \`onsale\`=? WHERE item_id=?`;
        const [res] = await db.query(Usql, [req.session.admin.account, 0, itemid]);
        
        output.result = res;
        if(res.affectedRows){
            if(res.changedRows){
                output.success = true;
                // 算錢
                const sql1 = "SELECT * FROM member WHERE account=?";
                const [rs1] = await db.query(sql1, [req.session.admin.account]);
                let bcoin = rs1[0].coin - price;
                const Usql0 = `UPDATE \`member\` SET \`coin\`=? WHERE pid=?`;
                const [res0] = await db.query(Usql0, [bcoin, req.session.admin.pid]);
                req.session.admin.coin -= price;
                
                const sqlu1 = "SELECT * FROM member WHERE account=?";
                const [rsu] = await db.query(sqlu1, [own]);
                let scoin = parseInt(rsu[0].coin, 10) - (tax - price);
                const Usql1 = `UPDATE \`member\` SET \`coin\`=? WHERE pid=?`;
                const [res1] = await db.query(Usql1, [scoin, ownid]);
                // TODO
            } else {
                output.error = '商品所有權沒有變更';
            }
        }else{
            output.error = '商品修改失敗';
        }
    }else{
        output.error = '新增交易紀錄失敗';
    }
    res.json(output);
    }
});
// ==== market ends ====

// ==== member access ====
app.get('/login',(req, res)=>{
    res.render('login');
});
app.post('/login',async (req, res)=>{
    const output = {
        success: false,
        error: '',
        postData: req.body,
    };
    if(!req.body.account || !req.body.password){
        output.error = '資料不足';
        return res.json(output);
    }

    const sql = "SELECT * FROM member WHERE account=?";
    const [rs]= await db.query(sql,[req.body.account]);
    if(!rs.length){
        output.error='帳號錯誤';
        return res.json(output);
    }

    const result = await bcrypt.compare(req.body.password, rs[0].password);
    if(result){
        req.session.admin = {
            pid: rs[0].pid,
            account: rs[0].account,
            nickname: rs[0].nickname,
            enable: rs[0].enable,
            coin: rs[0].coin,
            vip: rs[0].vip
        };
        output.success = true;
    }else{
        output.error = '密碼錯誤';
    }

    res.json(output);
});
app.get('/logout',(req, res)=>{
    delete req.session.admin;
    res.redirect('/');
});

app.get('/signup',(req, res)=>{
    res.render('signup');
});
app.post('/signup',async (req, res)=>{
    const output = {
        success: false,
        error: '',
        postData: req.body,
    };
    // const acc = req.body.account;
    // const nick = req.body.nickname;
    insertok = false;
    if(!req.body.account || !req.body.password){
        output.error = '資料不足';
        return res.json(output);
    }
    if(req.body.pwdCK != req.body.password){
        output.error = '密碼不一樣';
        return res.json(output);
    }

    const sql = "SELECT * FROM member WHERE account=?";
    const [rs]= await db.query(sql,[req.body.account]);
    if(!rs.length){
        const sql2 = "SELECT * FROM member WHERE email=?";
        const [rs2]= await db.query(sql2,[req.body.email]);
        if(!rs2.length){
            const ins = "INSERT INTO `member`(`account`, `nickname`, `password`, `email`, `created_at`,`enable`,`coin`) VALUES (?, ?, ?, ?, ?,?, ?)";
            const now = new Date();
            const hash = await bcrypt.hash(req.body.password, 8);

            const [result] = await db.query(ins, [req.body.account, req.body.nickname, hash, req.body.email, now, 1, 100]);
            console.log(result);
            if(result){insertok=true;}
        }else{
            output.error = '信箱重複';
            return res.json(output);
        }
    }else{
        output.error = '帳號重複';
        return res.json(output);
    }

    console.log('index');
    if(insertok){
        req.session.admin = {
            account: req.body.account,
            nickname: req.body.nickname,
            enable: 1,
            coin: 100,
            vip: 0,
        };
        output.success = true;
    }else{
        output.error = 'insert錯誤';
    }

    res.json(output);
});
// ==== member access ends ====


app.get('/about',(req, res)=>{
    res.render('about');
});


// === test login ====
app.use((req, res, next)=>{
    if(!req.session.admin){
        res.redirect('/login');
    } else {
        next();
    }
});
// ==== 

app.get('/member',(req, res)=>{
    res.render('member');
});

app.get('/follow',(req, res)=>{
    res.render('follow');
});

app.get('/vender',(req, res)=>{
    res.render('vender');
});

app.get('/depository',(req, res)=>{
    res.render('depository');
});

// app.get('/search',(req, res)=>{
//     res.render('search');
// });

// ===== 404 =========
app.use((req, res)=>{
    res.type('text/html').status(404).send(`<h1>Wrong URL</h1>`);
});

const port = process.env.PORT || 3000;
app.listen(port, ()=>{
    console.log('Webserver starts @: '+port);
});

