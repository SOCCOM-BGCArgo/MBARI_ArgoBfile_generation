function [stdate] = writedate

     curtime=clock;

     stdate(1:4)=num2str(curtime(1));
     if (curtime(2) < 10)
       stdate(6:6)=num2str(curtime(2));
       stdate(5:5)='0';
     else
       stdate(5:6)=num2str(curtime(2));
     end
     if (curtime(3) < 10)
       stdate(8:8)=num2str(curtime(3));
       stdate(7:7)='0';
     else
       stdate(7:8)=num2str(curtime(3));
     end
     if (curtime(4) < 10)
       stdate(10:10)=num2str(curtime(4));
       stdate(9:9)='0';
     else
       stdate(9:10)=num2str(curtime(4));
     end
     if (curtime(5) < 10)
       stdate(12:12)=num2str(curtime(5));
       stdate(11:11)='0';
     else
       stdate(11:12)=num2str(curtime(5));
     end
     if (fix(curtime(6)) < 10)
       stdate(14:14)=num2str(fix(curtime(6)));
       stdate(13:13)='0';
     else
       stdate(13:14)=num2str(fix(curtime(6)));
     end
  return
