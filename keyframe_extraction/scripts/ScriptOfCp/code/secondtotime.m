function time = secondtotime(s)
%-----------by chenpei------------
 hour=floor(s/(60*60));
 minute=floor((s-hour*60*60)/60);
 second=floor(s-hour*60*60-minute*60);
 
 time = strcat(int2str(hour),':',int2str(minute),':',int2str(second));