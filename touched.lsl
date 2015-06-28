default
{
    state_entry() { llSetAlpha(0, ALL_SIDES); }
    on_rez(integer start_param) { llSetAlpha(0, ALL_SIDES); }
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT, 0, llGetObjectName(), llDetectedKey(0));
    }
}
