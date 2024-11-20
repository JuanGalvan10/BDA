from flask_mysqldb import MySQL

mysql = MySQL()

def init_app(app):
    mysql.init_app(app)
