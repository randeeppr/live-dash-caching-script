#!/bin/bash
#The script download the manifest file of the given dash stream, parse it and downloads the m4s chunks from the stream. logs the details to dash.log in the current directory.
#Revision 1.0
#author : Randeep
#Contact : randeep123@gmail.com

#Assumptions
#manifest has only one chunk file.
#chunk size is 2 seconds.
#Manifest duration is 2.2s.

#Reading the url
#echo -e "Enter the dash url:"
#read url
#echo -e "url is : $url"
#creating channel directory
if [ ! -d channels ];then
        mkdir channels
fi
cd channels

url=$1
channelname=`echo $url | cut -d "/" -f 5`
if [ -d $channelname ]
then
        echo -e "Directory $channelname exists"
else
        cd /root/dash/channels/
        mkdir $channelname
fi
cd /root/dash/channels/$channelname

#Setting infinite loop
while true
do
        #Deleting the existing manifest and m4s files from the current directory
        rm -f manifest.* *.m4s

        #Getting the manifest file of the dash stream
        wget $url -o /dev/null

        #creating the base url
        #http://www.example.com/publishingdir/channelname/manifest.mpd http://www.example.com/publishingdir/channelname
        baseurl=`echo $url | cut -d "/" -f 1,2,3,4,5`
        #echo $baseurl

        #getting the representation id
        rep1=`cat manifest.mpd | awk -F "Representation id=" '{print $2}' | cut -d " " -f 1 | sed -e 's/^"//'  -e 's/"$//'`

        #Getting the startnumber
        startnumber=`cat manifest.mpd | awk -F "startNumber=" '{print $2}' | cut -d " " -f 1 | sed -e 's/^"//'  -e 's/"$//'`

        #Getting the chunk(s)
        chunkurl=$baseurl/$rep1-0-I-$startnumber.m4s
#        echo -e "`date` $chunkurl" >> dash.log
        wget $chunkurl -O /dev/null -o /dev/null

        #deleting the files
        rm -f manifest.* *.m4s
done
