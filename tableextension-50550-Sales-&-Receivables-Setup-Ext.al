tableextension 50550 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Auto Confirm Customer Change"; Boolean)
        {
            Caption = 'Auto Confirm Customer Change';
            DataClassification = CustomerContent;
        }
    }
}