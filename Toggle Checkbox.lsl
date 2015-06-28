integer on = FALSE;
string delimiter = ";";
turnOn()
{
    on = TRUE;
    llOffsetTexture(0.25, 0.75, ALL_SIDES);
}
turnOff()
{
    on = FALSE;
    llOffsetTexture(0.75, 0.75, ALL_SIDES);
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
        if(on == TRUE) turnOff(); else turnOn();
        llMessageLinked(LINK_ROOT, 0, llGetObjectDesc() + delimiter + (string)on, NULL_KEY);
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        if(str == llGetObjectDesc() + delimiter + "0") turnOff();
        if(str == llGetObjectDesc() + delimiter + "1") turnOn();
    }
}