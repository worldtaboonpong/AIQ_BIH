public class Util {
 public static string numberToThaiBahtText(Double val){
        if(val < 0) val = val * -1;
        string strStung = '';
        string[] thaiNum = new string[10];
        thaiNum[0] = '';
        thaiNum[1] = 'หนึ่ง';
        thaiNum[2] = 'สอง';
        thaiNum[3] = 'สาม';
        thaiNum[4] = 'สี่';
        thaiNum[5] = 'ห้า';
        thaiNum[6] = 'หก';
        thaiNum[7] = 'เจ็ด';
        thaiNum[8] = 'แปด';
        thaiNum[9] = 'เก้า';
        string[] uNum = new string[7];
        uNum[0] = '';
        uNum[1] = 'สิบ';
        uNum[2] = 'ร้อย';
        uNum[3] = 'พัน';
        uNum[4] = 'หมื่น';
        uNum[5] = 'แสน';
        uNum[6] = 'ล้าน';
        
        string NumTxt = val.format();
        NumTxt = NumTxt.replace(',', '');
       // System.debug('****' + NumTxt);
        
        //สตางค์
        string SNumTxt = '';
        String[] SNumAr = null;
        if (NumTxt.indexOf('.') != -1)
        {
            SNumTxt = NumTxt.substring(NumTxt.indexOf('.') + 1);
           // System.debug('****SNumTxt:' + SNumTxt);
            SNumAr = SNumTxt.split('');
         //   System.debug('****SNumAr1:' + SNumAr);
            if(SNumAr.size() > 0) if(SNumAr[0] == '')SNumAr.remove(0);
          //  System.debug('****SNumAr2:' + SNumAr);
            if (SNumTxt.equals('00') || SNumTxt.equals('0'))
                strStung = 'ถ้วน';
            else
            {
                strStung = 'สตางค์';
                if(SNumAr.size() == 1)
                {
                    if(SNumAr[0] == '2')
                        strStung = 'ยี่' + uNum[1] + strStung;
                    else
                        strStung = thaiNum[Integer.valueOf(SNumAr[0])] + uNum[1] + strStung;
                }
                else
                {
                    if (SNumAr[1] == '1' && SNumAr[0] != '0')
                        strStung = 'เอ็ด' + strStung;
                    else
                        strStung = thaiNum[Integer.valueOf(SNumAr[1])] + strStung;

                    if (SNumAr[0] == '2')
                        strStung = 'ยี่' + uNum[1] + strStung;
                    else if (SNumAr[0] == '1')
                        strStung = uNum[1] + strStung;
                    else if (SNumAr[0] != '0')
                        strStung = thaiNum[Integer.valueOf(SNumAr[0])] + uNum[1] + strStung;
                }
                
            }
        }
        else
        {
            strStung = 'ถ้วน';
        }
        //บาท
        if (NumTxt.indexOf('.') != -1)
            NumTxt = NumTxt.substring(0, NumTxt.indexOf('.'));
        strStung = 'บาท' + strStung;
      //  System.debug('****' + strStung );
        
        string strOutBath = '';
        
        if (NumTxt.equals('0'))
            strOutBath = 'ศูนย์';
        String[] NumTxtArr = NumTxt.split('');
        if(NumTxtArr[0] == '' || NumTxtArr[0] == ' ') NumTxtArr.remove(0);
        Integer NumPos = 0; //ตำแหน่งตัวเลข             0    1      2     3     4      5      6
        Integer NumMod = 0; //ตำแหน่งหน่วย --- { '', 'สิบ', 'ร้อย', 'พัน', 'หมื่น', 'แสน', 'ล้าน' };
        Integer Num;
        Integer MaxLen = NumTxtArr.size();
      //  System.debug('****NumTxt' +NumTxt);
      //  System.debug('****NumTxtArr' +NumTxtArr);
        if (MaxLen > 19)
            return 'ไม่สามารถแปลงค่ามากกว่าล้านล้านล้านได้';
        for (Integer i = 0; i < MaxLen; i++)
        {
       //    system.debug('****strOutBath:' + strOutBath);
            Num = Integer.valueOf(NumTxtArr[i]);
            NumPos = NumTxtArr.size() - i;
      //      system.debug('****Num:' + string.valueOf(Num));
      //      system.debug('****NumPos:' + string.valueOf(NumPos));
            if (NumPos > 13)
                NumMod = Math.mod((NumPos - 6), 7);
            else if (NumPos > 7)
                NumMod = Math.mod(NumPos, 7);
            else
                NumMod = NumPos - 1;
            if (Num == 0)
            {
                if (NumPos == 7 || NumPos == 13 || NumPos == 19)
                {
                    strOutBath = strOutBath + thaiNum[Num] + uNum[NumMod];
                }
            }
            else
            {
                if (NumPos == 1 || NumPos == 7 || NumPos == 13 || NumPos == 19)
                {//หลักหน่วย,ล้าน,ล้านๆ,ล้านๆๆ
                    if (MaxLen > NumPos) //มีหลักสิบ
                    {
                        if (NumTxtArr[i - 1] != '0' && NumTxtArr[i] == '1') //หลักสิบไม่ใช่ 0
                            strOutBath = strOutBath + 'เอ็ด' + uNum[NumMod];
                        else
                            strOutBath = strOutBath + thaiNum[Num] + uNum[NumMod];
                    }
                    else
                        strOutBath = strOutBath + thaiNum[Num] + uNum[NumMod];
                }
                else if (NumPos == 2 || NumPos == 8 || NumPos == 14)
                {//หลักสิบ,สิบล้าน,สิบล้านๆ
                    if (NumTxtArr[i] == '2')
                        strOutBath = strOutBath + 'ยี่' + uNum[NumMod];
                    else if (NumTxtArr[i] == '1')
                        strOutBath = strOutBath + uNum[NumMod];
                    else
                        strOutBath = strOutBath + thaiNum[Num] + uNum[NumMod];
                }
                else
                {
                    strOutBath = strOutBath + thaiNum[Num] + uNum[NumMod];
                }
            }
        }
        return strOutBath + strStung;
    }

    public static string dateToStringDateYYYYEN(Date dt){
        try{
            Integer iYear = dt.year() > 2500 ? dt.year() - 543 : dt.year();
            return pad2(dt.day()) + '/' + pad2(dt.month()) + '/' + iYear;
        }
        catch(Exception ex){return '';}
    }

    public static string dateToStringDateYYYYTH(Date dt){
        try{
            Integer iYear = dt.year() < 2500 ? dt.year() + 543 : dt.year();
            return pad2(dt.day()) + '/' + pad2(dt.month()) + '/' + iYear;
        }
        catch(Exception ex){return '';}
    }
    
    public static String pad2(Integer val) {
        if (val < 10) {
            return '0' + val;
        }
        return '' + val;
    }
}