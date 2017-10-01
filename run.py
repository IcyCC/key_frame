from server import app

if __name__ == '__main__':
    setting = {
    'REQUEST_TIMEOUT':10000
    }
    app.config.update(setting)
    app.run(host="127.0.0.1", port=5000, debug=True)

