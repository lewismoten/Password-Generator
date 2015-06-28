integer length = 10;
integer useLowercase = TRUE;
integer useUppercase = FALSE;
integer useNumbers = FALSE;
integer usePunctuation = FALSE;
integer useSimilar = TRUE;
integer useHex = FALSE;

string lowercase = "abcdefghijklmnopqrstuvwxyz";
string uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
string numbers = "0123456789";
string hex = "0123456789abcdef";
string punctuation = "`~!@#$%^&*()_-+={}|[]\:\";'<>?,./";
string similarCharacters = "iIl1!|0OoA4ha@e2C(E[{3G5S$Z";

integer lowercaseLen;
integer uppercaseLen;
integer numbersLen;
integer punctuationLen;
integer hexLen;

Synch()
{
    llMessageLinked(LINK_ALL_OTHERS, 0, "Numbers;" + (string)useNumbers, NULL_KEY);
    llMessageLinked(LINK_ALL_OTHERS, 0, "Uppercase;" + (string)useUppercase, NULL_KEY);
    llMessageLinked(LINK_ALL_OTHERS, 0, "Lowercase;" + (string)useLowercase, NULL_KEY);
    llMessageLinked(LINK_ALL_OTHERS, 0, "Hex;" + (string)useHex, NULL_KEY);
    llMessageLinked(LINK_ALL_OTHERS, 0, "Punctuation;" + (string)usePunctuation, NULL_KEY);
    llMessageLinked(LINK_ALL_OTHERS, 0, "Similar;" + (string)useSimilar, NULL_KEY);
    llMessageLinked(LINK_ALL_OTHERS, length, "LengthValue", NULL_KEY);
}
SetDefault()
{
    useNumbers = FALSE;
    useUppercase = FALSE;
    useLowercase = TRUE;
    useHex = FALSE;
    usePunctuation = FALSE;
    useSimilar = FALSE;
    length = 8;
    Synch();
}
SetGuid()
{
    useNumbers = FALSE;
    useUppercase = FALSE;
    useLowercase = FALSE;
    useHex = TRUE;
    usePunctuation = FALSE;
    useSimilar = TRUE;
    length = 32;
    Synch();
}
SetStrong()
{
    useNumbers = TRUE;
    useUppercase = TRUE;
    useLowercase = TRUE;
    useHex = FALSE;
    usePunctuation = TRUE;
    useSimilar = TRUE;
    length = 12;
    Synch();
}
string newpassword()
{
    integer requiredCount = useLowercase + useUppercase + useNumbers + usePunctuation + useHex;
    if(requiredCount == 0) return "[error]";
    if(requiredCount > length) return "[error]";

        @tryagain;
    string password;
    integer j;
    integer i;
    for(i = 0; i < length;)
    {
        integer switch = (integer)llFrand(10000) % 5;
        string char = "";
        if(switch == 0 && useLowercase)
        {
            j = (integer)llFrand(10000) % lowercaseLen;
            char = llGetSubString(lowercase, j, j);
        }
        else if(switch == 1 && useUppercase)
        {
            j = (integer)llFrand(10000) % uppercaseLen;
            char = llGetSubString(uppercase, j, j);
        }
        else if(switch == 2 && useNumbers)
        {
            j = (integer)llFrand(10000) % numbersLen;
            char = llGetSubString(numbers, j, j);
        }
        else if(switch == 3 && usePunctuation)
        {
            j = (integer)llFrand(10000) % punctuationLen;
            char = llGetSubString(punctuation, j, j);
        }
        else if(switch == 4 && useHex)
        {
            j = (integer)llFrand(10000) % hexLen;
            char = llGetSubString(hex, j, j);
        }
        if(char != "" &! useSimilar)
            if(llSubStringIndex(similarCharacters, char) != -1)
                char = "";
        if(char != "") i++;
        password+= char;
    }
    if(usePunctuation &! findMatch(password, punctuation)) jump tryagain;
    if(useLowercase &! findMatch(password, lowercase)) jump tryagain;
    if(useUppercase &! findMatch(password, uppercase)) jump tryagain;
    if(useNumbers &! findMatch(password, numbers)) jump tryagain;
    if(useHex &! findMatch(password, hex)) jump tryagain;
    
    return password;
}
integer findMatch(string password, string characters)
{
    integer i;
    integer n = llStringLength(password);
    for(i = 0; i < n; i++)
        if(llSubStringIndex(characters, llGetSubString(password, i, i)) != -1)
            return TRUE;
    return FALSE;
}
default
{
    state_entry()
    {
        lowercaseLen = llStringLength(lowercase);
        uppercaseLen = llStringLength(uppercase);
        numbersLen = llStringLength(numbers);
        punctuationLen = llStringLength(punctuation);
        hexLen = llStringLength(hex);
        SetDefault();
    }
    link_message(integer sender, integer num, string msg, key id)
    {
        list params = llParseString2List(msg, [";"], []);
        string command = llList2String(params, 0);
        
        if(command == "Generate") llInstantMessage(id, newpassword());
        else if(command == "Numbers") useNumbers = llList2Integer(params, 1);
        else if(command == "Uppercase") useUppercase = llList2Integer(params, 1);
        else if(command == "Lowercase") useLowercase = llList2Integer(params, 1);
        else if(command == "Hex") useHex = llList2Integer(params, 1);
        else if(command == "Punctuation") usePunctuation = llList2Integer(params, 1);
        else if(command == "Similar") useSimilar = llList2Integer(params, 1);
        else if(command == "Default") SetDefault();
        else if(command == "Strong") SetStrong();
        else if(command == "Guid") SetGuid();
        else if(command == "Length")
        {
            length += llList2Integer(params, 1);
            if(length < 1) length = 1;
            if(length > 64) length = 64;
            llMessageLinked(LINK_ALL_OTHERS, length, "LengthValue", NULL_KEY);
        }
    }
}
