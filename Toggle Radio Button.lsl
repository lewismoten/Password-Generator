integer on = FALSE;
string delimiter = ";";
turnOn()
{
    on = TRUE;
    llOffsetTexture(0.25, 0.25, ALL_SIDES);
}
turnOff()
{
    on = FALSE;
    llOffsetTexture(0.75, 0.25, ALL_SIDES);
}
default
{
    state_entry()
    {
        turnOff();
    }
    on_rez(integer start_param)
    {
        turnOff();
    }
    touch_start(integer total_number)
    {
        if(!on) turnOn();
        llMessageLinked(LINK_ALL_OTHERS, 0, llGetObjectDesc(), NULL_KEY);
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        string desc = llGetObjectDesc();
        list params = llParseString2List(desc, [delimiter], []);
        string command = llList2String(params, 0);
        if(str == desc) turnOn();
        else if(llSubStringIndex(str, command) == 0) turnOff();
    }
}