import ujson
import aiofiles
import sanic
from celery import Celery
from sanic.response import json, file_stream
from sanic.request import Request
from redis_middle.redis_middle_class import Conn_db
from . import celery_config
from engine import eng

app = sanic.Sanic(__name__)
app.debug = True


celery_app = Celery()
celery_app.config_from_object(celery_config)

redis_db = Conn_db()


video_url = "keyframe_extraction/scripts/ScriptOfCp/"
base_url = '/static/'


app.static('/static', 'keyframe_extraction/scripts/ScriptOfCp')


@app.route("/key_frames", methods=['GET'])
async def upload_key_word(request):
    key_word = request.args.get('word')

    result = eng.get_info(key_word, nargout=1)
    resp = dict(video_url=video_url+result[0][0], data=list())

    for item in result:
        resp.get('data', []).append({'video_name': item[0],
                                    "image_url": base_url+item[1],
                                     "time": item[2]})
    return json(body=resp)


@app.route('/video', methods=['GET', 'POST'])
async def get_video(request:Request):
    if request.method == 'GET':
        path = request.args.get('path')
        return await file_stream(path)

    if request.method == 'POST':
        video_file = request.files.get("video")

        if video_file.type != 'video/x-flv':
            return json(body={'status':'fail', 'reason':"only support flv"})

        async with aiofiles.open(video_url+'1.flv', 'wb') as f:
            await f.write(video_file.body)
        return json(body={'status':"success",'reason':''})


@app.route('/image', methods=['GET', 'POST'])
async def get_video(request:Request):
    if request.method == 'GET':
        path = request.args.get('path')
        return await file_stream(path)

    if request.method == 'POST':
        image_file = request.files.get("image")

        if image_file.type != '	application/x-jpg' and image_file.type != 'image/jpeg':
            print(image_file.type)
            return json(body={'status':'fail', 'reason':"only support jpg"})

        image_url = video_url+'1.jpg'

        async with aiofiles.open(image_url, 'wb') as f:
            await f.write(image_file.body)
        return json(body={'status':"success",'reason':''})


def write_to_redis(resp):
    r = resp.result()
    return r
