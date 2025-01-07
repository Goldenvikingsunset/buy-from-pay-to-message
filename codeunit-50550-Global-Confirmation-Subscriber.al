codeunit 50550 "Sales Document Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnAfterTestStatusOpen', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnAfterTestStatusOpen(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if SalesHeader.Status in [SalesHeader.Status::Released, SalesHeader.Status::"Pending Approval"] then begin
            Message('Document must be in Open status to modify. Current status: %1\Please use the Reopen action first.', SalesHeader.Status);
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnAfterCalcShouldSkipConfirmSellToCustomerDialog', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnAfterCalcShouldSkipConfirmSellToCustomerDialog(var SalesHeader: Record "Sales Header"; var ShouldSkipConfirmSellToCustomerDialog: Boolean; var ConfirmedShouldBeFalse: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if HasWarehouseShipments(SalesHeader) then begin
            Message('Cannot change customer when warehouse shipments exist.\Please delete the warehouse shipments first.');
            ShouldSkipConfirmSellToCustomerDialog := true;
            ConfirmedShouldBeFalse := true;
            exit;
        end;

        SalesSetup.Get();
        if SalesSetup."Auto Confirm Customer Change" then begin
            if HasSalesLines(SalesHeader) then begin
                if not Confirm('If you change Sell-to Customer, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created. Do you want to continue?', false) then begin
                    ShouldSkipConfirmSellToCustomerDialog := true;
                    ConfirmedShouldBeFalse := true;
                    exit;
                end;
            end;
            ShouldSkipConfirmSellToCustomerDialog := true;
            ConfirmedShouldBeFalse := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeConfirmBillToCustomerChange', '', false, false)]
    local procedure OnBeforeConfirmBillToCustomerChange(SalesHeader: Record "Sales Header"; var Confirmed: Boolean; var IsHandled: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if HasWarehouseShipments(SalesHeader) then begin
            Message('Cannot change customer when warehouse shipments exist.\Please delete the warehouse shipments first.');
            Confirmed := false;
            IsHandled := true;
            exit;
        end;

        SalesSetup.Get();
        if SalesSetup."Auto Confirm Customer Change" then begin
            Confirmed := true;
            IsHandled := true;
        end;
    end;

    local procedure HasSalesLines(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        exit(not SalesLine.IsEmpty);
    end;

    local procedure HasWarehouseShipments(SalesHeader: Record "Sales Header"): Boolean
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        WarehouseShipmentLine.SetRange("Source Type", Database::"Sales Line");
        WarehouseShipmentLine.SetRange("Source Subtype", SalesHeader."Document Type");
        WarehouseShipmentLine.SetRange("Source No.", SalesHeader."No.");
        exit(not WarehouseShipmentLine.IsEmpty);
    end;
}