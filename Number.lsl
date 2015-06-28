showNumber(integer number)
{
    integer row = number % 10;
    integer column = (number - row) / 10;
    llOffsetTexture(-.45 + (column * .1), .45 + (row * -.1), ALL_SIDES);
}
default
{
    link_message(integer sender, integer number, string msg, key id)
    {
        if(msg == llGetObjectDesc()) showNumber(number);
    }
}
