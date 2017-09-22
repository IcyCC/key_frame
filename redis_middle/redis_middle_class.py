import redis
import pickle


class Conn_db():
    def __init__(self):
        # 创建对本机数据库的连接对象
        self.conn = redis.StrictRedis(host='127.0.0.1', port=6379, db=3)
        # 统一 测试级别是3

    def __call__(self, *args, **kwargs):
        return self.conn

    def pipline(self):
        return self.conn.pipeline()

    # 存储
    def set(self, key_, value_):
        value_ = pickle.dumps(value_)
        self.conn.set(key_, value_)

    def hset(self, name, key_, value_):
        value_ = pickle.dumps(value_)
        self.conn.hset(name, key_, value_)

    # 读取
    def get(self, key_):
        value_ = self.conn.get(key_)
        if value_ is not None:
            value_ = pickle.loads(value_)
            return value_
        else:
            return None

    def hget(self, name, key_):
        value_ = self.conn.hget(name, key_)
        if value_ is not None:
            value_ = pickle.loads(value_)
            return value_
        else:
            return []

    # 删除

    def delete(self, key_):
        self.conn.delete(key_)

    def hdelete(self, name, *key):
        self.conn.hdel(name, *key)