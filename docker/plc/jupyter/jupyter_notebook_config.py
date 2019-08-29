c.NotebookApp.tornado_settings = {
    'headers': { 
        'Content-Security-Policy': "frame-ancestors tramberend.beuth-hochschule.de localhost:* http: https: 'self';"
        }
    }
c.NotebookApp.token = "plc"
c.NotebookApp.allow_origin = '*' 