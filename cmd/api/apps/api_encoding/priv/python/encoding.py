#!/bin/env python3
from os import path
import moviepy.editor as mp

from erlport.erlterms import Atom
from erlport.erlang import set_message_handler, cast

#
# VideoEncoder class
# TODO: Maybe move this class into another file
#

class VideoEncoder:
    filename = None
    worker = None
    clip = None
    supported_size = [1080, 720, 480, 360, 240]

    def __init__(self, worker, filename):
        self.worker = worker
        self.filename = filename
        self.clip = mp.VideoFileClip(filename.decode())

    def check_video_size(self):
        try:
            self.supported_size.index(self.clip.h)
            return True
        except ValueError:
            return False

    def downsize_video(self):
        base = path.basename(self.filename)
        filename = path.splitext(base)[0]
        ind_size = self.supported_size.index(self.clip.h)

        for new_heigth in self.supported_size[ind_size:]:
            resized = self.clip.resize(height=new_heigth)
            new_filename = 'videos/{}_{}.mp4'.format(filename, new_heigth)
            resized.write_videofile(new_filename, codec='libx264', threads=4, verbose=False, logger=None)

#
# Public API
#

encoder: VideoEncoder = None

def register_video(pid, filename):
    global encoder

    def handler(message):
        print("K mek")
        cast(pid, message)

    encoder = VideoEncoder(pid, filename)

    if not encoder.check_video_size():
        return (Atom(b'error'), Atom(b'unknown_size'))

    set_message_handler(handler)
    return (Atom(b'ok'),)
