@isTest
public class NumberToTextTest {
    @isTest
    static void testConvert() {
        
        NumberToText.convert(-100);
        NumberToText.convert(100);
        NumberToText.generateTextForTwoDigits(50);
        // Test positive values
        System.assertEquals('Zero', NumberToText.convert(0));
        System.assertEquals('One', NumberToText.convert(1));
        System.assertEquals('Ten', NumberToText.convert(10));
        System.assertEquals('Twenty', NumberToText.convert(20));
        System.assertEquals('Twenty-One', NumberToText.convert(21));
        System.assertEquals('One Hundred', NumberToText.convert(100));
        System.assertEquals('One Hundred Twenty-Three', NumberToText.convert(123));
        System.assertEquals('One Thousand', NumberToText.convert(1000));
        System.assertEquals('One Thousand Two Hundred Thirty-Four', NumberToText.convert(1234));
        System.assertEquals('One Million', NumberToText.convert(1000000));
        System.assertEquals('One Million Two Hundred Thirty-Four Thousand Five Hundred Sixty-Seven', NumberToText.convert(1234567));

        // Test negative values
        System.assertEquals('Negative One', NumberToText.convert(-1));
        System.assertEquals('Negative One Thousand Two Hundred Thirty-Four', NumberToText.convert(-1234));
        System.assertEquals('Negative One Million Two Hundred Thirty-Four Thousand Five Hundred Sixty-Seven', NumberToText.convert(-1234567));
        
        
                
    }
    
    
  
}