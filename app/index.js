const express = require('express');
const app = express(); 
const port = 8080;


app.get('/', (req, res) => {  
    res.sendFile('home.html', {root: __dirname});
                                                        
});

app.listen(port, () => {           
    console.log(`Now listening on port ${port}`); 
});