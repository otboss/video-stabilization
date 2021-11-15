#/bin/bash
# Sources:
# https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos
# https://stackoverflow.com/questions/11552565/vertically-or-horizontally-stack-several-videos-using-ffmpeg
# https://ffmpeg.org/pipermail/ffmpeg-user/2017-August/037057.html

path="/usr/bin/"

if [ -z "$1" ]
    then
        echo "Usage:" 
        echo  "stabilizator.sh filename.mp4"
        exit 0
fi

# one step
$path/ffmpeg -y -i $1 \
      -vf vidstabtransform,unsharp=5:5:0.8:3:3:0.4 ${1%.*}_oneStep.mp4

# two steps
$path/ffmpeg -y -i $1 \
      -vf vidstabdetect=stepsize=32:shakiness=10:accuracy=10:result=transforms.trf -f null -
$path/ffmpeg -y -i $1 \
      -vf vidstabtransform=input=transforms.trf:zoom=0:smoothing=10,unsharp=5:5:0.8:3:3:0.4 \
      -vcodec libx264 -tune film -acodec copy -preset slow  \
      ${1%.*}_twoSteps.mp4
