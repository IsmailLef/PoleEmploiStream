const express = require('express');
const path = require('path');
const cassandra = require('cassandra-driver');

const contactPoints = ['cassandra'];
const localDataCenter = 'dc1';
const client = new cassandra.Client({ contactPoints: contactPoints, localDataCenter: localDataCenter,  keyspace: 'offresemploi'});

const app = express();
const port = 3001;

app.use(express.static(path.join(__dirname, 'static')));

app.get('/departement/:code', async (req, res) => {
    await client.connect();
    
    const departementCode = req.params.code;
    
    const secondQuery = 'SELECT count FROM jobs_departements WHERE code=?';
    const thirdQuery = 'SELECT libelle FROM departements WHERE code=?';
    const secondParams = [departementCode];
    
    try {
        const secondResult = await client.execute(secondQuery, secondParams, { prepare: true });
        const secondRow = secondResult.first();
        
        const thirdResult = await client.execute(thirdQuery, secondParams, { prepare: true });
        const thirdRow = thirdResult.first();
        
        const count = secondRow ? secondRow.count : 0;
        
        res.json({message:`${count} offres ont été récupérées dans la commune ${departementCode}`, data: {count:count, name:thirdRow.libelle}})
    } catch (error) {
        res.status(500).send('Error lors de la 2 req')
    }    
})

// Démarrer le serveur
app.listen(port, () => {
    console.log(`Serveur démarré sur: http://localhost:${port}`);
});