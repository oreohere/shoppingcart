from flask import Flask, render_template, json, request,redirect,flash
import MySQLdb
from flask import session
from jinja2 import Environment
import sys
#from Tkinter import *

app = Flask(__name__)
app.secret_key = '1111'

@app.route('/')
def main():
    return render_template('index.html')

@app.route('/signUp')
def signUp():
    return render_template('signup.html')

@app.route('/showSignUp',methods=['POST','GET'])
def showSignUp():
    try:
        _name = request.form['inputName']
        _email = request.form['inputEmail']
        _password = request.form['inputPassword']
        # validate the received values
        if _name and _email and _password:
            # All Good, let's call MySQL       
            conn = MySQLdb.Connect(host="127.0.0.1",user="root",
                  passwd="1234",db="shopping_cart",port=3306)
            cursor = conn.cursor()
            cursor.callproc('sp_createUser',(_name,_email,_password))
            data = cursor.fetchall()
            print data
            if len(data) is 0:
                conn.commit()
                return redirect('/')
            else:
                return render_template('error.html',error = 'Email address or Name has already been used.')
        else:
            return json.dumps({'html':'<span>Enter the required fields</span>'})

    except Exception as e:
        #return json.dumps({'error':str(e)})
        return render_template('signup.html')
    finally:
        cursor.close() 
        conn.close()

@app.route('/login')
def showSignin():
    return render_template('login.html')

@app.route('/validateLogin',methods=['POST'])
def validateLogin():
    try:
        _useremail = request.form['inputEmail']
        _password = request.form['inputPassword']
        con = MySQLdb.Connect(host="127.0.0.1",user="root",
                  passwd="1234",db="shopping_cart",port=3306)
        cursor = con.cursor()
        cursor.callproc('sp_validateLogin',(_useremail,))
        data = cursor.fetchall()
        if len(data) > 0:
            #if check_password_hash(str(data[0][3]),_password):
            if(str(data[0][3])==_password):
                session['user'] = data[0][0]
                return redirect('/userHome')
            else:
                return render_template('error.html',error = 'Wrong Email address or Password!')
        else:
            return render_template('error.html',error = 'User doesnot exist!')
 
    except Exception as e:
        return render_template('error.html',error = str(e))
    finally:
        cursor.close()
        con.close()

@app.route('/userHome')
def userhome():
    try:
        if session.get('user'):
            con = MySQLdb.connect(host="127.0.0.1",user="root",
                  passwd="1234",db="shopping_cart",port=3306)
            cursor = con.cursor()
            cursor.execute("select * from tbl_inventory;")
            wishes = cursor.fetchall()
            return render_template('userHome.html',wishes=wishes)
        else:
            return render_template('error.html',error = 'Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error = str(e))
    finally:
        cursor.close()
        con.close()

@app.route('/showCart')
def showCart():
    try:
        if session.get('user'):
            _user = session.get('user')
            con = MySQLdb.connect(host="127.0.0.1",user="root",
                  passwd="1234",db="shopping_cart",port=3306)
            cursor = con.cursor()
            cursor.execute("select * from tbl_wish natural join tbl_inventory where user_id = (%s);",(_user,))
            wishes = cursor.fetchall()
            flash("going to cart")
            total = sum([i[7] for i in wishes])

            return render_template('showCart.html', wishes=wishes,total=total)
        else:
            return render_template('error.html', error = 'Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error = str(e))
    finally:
        cursor.close()
        con.close()

@app.route('/addToCart', methods=['POST'])
def addToCart():
    try:
        if session.get('user'):
            _itemid = request.form['itemid']
            _user = session.get('user')
 
            conn = MySQLdb.connect(host="127.0.0.1",user="root",
                  passwd="1234",db="shopping_cart",port=3306)
            cursor = conn.cursor()
            cursor.callproc('sp_addWish',(_itemid,_user,))
            data = cursor.fetchall()
 
            if len(data) is 0:
                conn.commit()
                return redirect('/userHome')
            else:
                return render_template('error.html',error = 'An error occurred!')
 
        else:
            return render_template('error.html',error = 'Unauthorized Access')
    except Exception as e:
        return render_template('error.html',error = str(e))
    finally:
        cursor.close()
        conn.close()



@app.route('/logout')
def logout():
    session.pop('user',None)
    return redirect('/')


if __name__ == "__main__":
    app.run(port=5005)