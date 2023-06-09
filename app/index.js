const express = require('express');
const app = express(); 
const port = 5000;


app.get('/', (req, res) => {  
    res.sendFile('home.html', {root: __dirname});
                                                        
});

app.listen(port, () => {           
    console.log(`Now listening on port ${port}`); 
});