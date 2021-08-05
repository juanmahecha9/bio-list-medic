# Directorio del programa referente al backend

## Ejecución del programa node.js
La ejecución del programa se ejecuta con los siguientes comandos:

Enrutamiento a la carpeta del proyecto: cd Nombre_asiganado_a_la_carpeta.

Ejecución del servidor; para esto se puede usar uno de los siguientes comandos:

npm run start, comando con el cual se ejecuta el ambiente de pruebas con el uso de nodemon, paquete que monitorea los cambios en el código fuente que se esta desarrollando y automáticamente re inicia el servidor.
npm run serve, comando que ejecuta el ambiente de pruebas.
npm run build, comando que ejecuta la transpilación del proyecto a el lenguaje de javascript actual, manteniendo el servicio moderno.
npm run clean, cmando que permite eleminar la carpeta dist actual, para reemplazar por la nueva generada por el comando actual.
npm run start, comando que ejecuta la capeta de distribución

> NOTA IMPORTANTE:
Recuerda que al momento de cargar en un programa de control de versiones de codigo, en este caso GITHUB, es importan colocar en el archivo .gitignore la siguiente linea: ./src/private/*.json y ./src/security/*.json.

