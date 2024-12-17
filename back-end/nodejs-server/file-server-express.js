const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 8083;

// Habilitar el middleware 'cors' para permitir solicitudes desde cualquier origen
app.use(cors());

// Ruta para servir el archivo 'status_matrix.txt'
app.get('/config_matrix.txt', (req, res) => {
  const filePath = path.join(__dirname, 'config_matrix.txt');
         
  fs.readFile(filePath, 'utf8', (err, data) => {
     if (err) {
         console.error('Error al leer el archivo:', err);
         res.status(500).send('Error al leer el archivo');
     } else {
         res.status(200).send(data);
     }
   });
});

// Ruta para servir el archivo 'matrix_size.txt'
app.get('/matrix_size.txt', (req, res) => {
  const filePath = path.join(__dirname, 'matrix_size.txt');
         
  fs.readFile(filePath, 'utf8', (err, data) => {
     if (err) {
         console.error('Error al leer el archivo:', err);
         res.status(500).send('Error al leer el archivo');
     } else {
         res.status(200).send(data);
     }
   });
});

// Ruta para servir el archivo 'matrix_size.txt'
app.get('/time_diff.txt', (req, res) => {
  const filePath = path.join(__dirname, 'time_diff.txt');
         
  fs.readFile(filePath, 'utf8', (err, data) => {
     if (err) {
         console.error('Error al leer el archivo:', err);
         res.status(500).send('Error al leer el archivo');
     } else {
         res.status(200).send(data);
     }
   });
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
