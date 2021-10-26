stateDiagram-v2
    q0 : q0
    state "Offer_Open 😀" as q0
    [*] --> q0 : start
    q0 --> acCo : offer accepted & signed
    acCo : acCo
    state "active Contract 😀" as acCo
    Obl1 : Obl1
    state "Obligation_to_pay_license_fee and grant license 😀" as Obl1
    acCo --> Obl1 : payment and license requested
    Obl1 --> sFL : failure to license
    Obl1 --> sUP : failure to pay
    Obl1 --> inLic : payment made and license granted
    sUP: sUP
    LIT : LIT
    state "Litigation or arbitration" as LIT
    sUP --> LIT : litigation
    sFL --> LIT : litigation 
    sFL --> CANC : past statute of limitations or by agreement
    sUP --> CANC : past statute of limitations or by agreement
    sFL : sFL
    state "Failure_to_license" as sFL
    state "Failed obligation to pay" as sUP
    sFL --> CANC : canceled past statute of limitations or by agreement
    sFR --> LIT : litigation
    sFR : sFR
    state "Failed obligation to remove" as sFR
    acCo --> Obl5BrLic
    inLic : inLic
    state "Inactive_License" as inLic
    acCo --> TERM : mutual agreement
    acLic : acLic
    state "Active_License 😀" as acLic
    inLic --> acLic : license start date passes
    acLic --> inLic : license period ends
    acLic --> Obl6 : Non_Approved_Comments_Published
    Obl3 : Obl3
    state "Obligation_to_Publish 😀" as Obl3
    NObl4 : NObl4
    state "No_obligation_to_publish 😀" as NObl4
    acLic --> Obl3 : check_commissioned_pos
    acLic --> NObl4 : check_commissioned_neg
    %% also unclear in text if commissioned also has to submit for approval
    NObl4 --> waitAppr : comments within LP
    NObl4 --> TERM : term passes w/o incident
    Obl3 --> waitAppr : comments submitted
    sFP : sFP
    state "Failure_to_Publish" as sFP
    Obl3 --> sFP : commissioned, end of license w/o comments
    Obl7 : Obl7
    state "Obligation Pay Evaluation Fee 😀" as Obl7
    waitAppr --> Obl7
    waitAppr --> TERM : successful publication
    sFP --> CANC : stat of lim or agreement
    sFP --> LIT : litigation
    sFA : sFA
    state "failure_to_approve" as sFA
    sFA --> LIT : litigation
    sFA --> CANC : stat of lim or agreement
    inLic --> Obl6 : Comments_Published_Outside_License_Period
    NObl4 --> Obl6 : published_unapproved
    Obl3 --> Obl6 : published_unapproved
    Obl5BrLic : Obl5BrLic
    state "Obligation_to_pay_breach_fee (brLic)" as Obl5BrLic
    Obl5BrLic --> TERM : breach fee paid
    Obl5BrLic --> LIT : litigation
    Obl6 : Obl6
    state "Obligation_to_Remove_Comments" as Obl6
    Obl6 --> sFR : Healing_time_lapsed
    Obl6 --> Obl3 : Comments removed
    Obl6 --> inLic : Comments removed
    Obl6 --> NObl4 : Comments removed
    Obl7 --> sUP : failure to pay eval fee
    Obl7 --> TERM
    waitAppr : waitAppr
    state "Waiting_for_Approval 😀" as waitAppr
    waitAppr --> Obl3 : comments_rejected
    waitAppr --> sFA : approval overdue
    sUP --> Obl5BrLic : breach
    sFP --> Obl5BrLic : breach
    sFA --> Obl5BrLic : breach
    sFR --> Obl5BrLic : breach