from server import app

if __name__ == '__main__':
    setting = {
    'REQUEST_TIMEOUT':10000
    }
    app.config.update(setting)
    app.run(host="0.0.0.0", port=5000, debug=True)

