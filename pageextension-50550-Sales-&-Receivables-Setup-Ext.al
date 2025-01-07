pageextension 50550 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Auto Confirm Customer Change"; Rec."Auto Confirm Customer Change")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if customer change confirmations should be automatically confirmed.';
            }
        }
    }
}