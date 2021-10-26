stateDiagram-v2
    %% replace events with shorthand / short ids
    %% sublicenses omitted
    q0 : q0
    state "Offer_Open 😀" as q0
    [*] --> q0
    q0 --> acCo : offer accepted & signed
    acCo : acCo
    state "active Contract 😀" as acCo
    Obl1 : Obl1
    state "Obligation_to_pay_license_fee and grant license 😀" as Obl1
    acCo --> Obl1 : payment invoice and license requested
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
    acCo --> TERM
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
    NObl4 --> TERM
    %%Obl3 --> pub_or_no_pub
    Obl3 --> waitAppr : comments submitted
    %%pub_or_no_pub --> commSub
    %% this would need actually a specification of time, when it is a failure.
    sFP : sFP
    state "Failure_to_Publish" as sFP
    Obl3 --> sFP : commissioned, end of license w/o comments
    commPub : commPub
    state "Comments_Published 😀" as commPub
    waitAppr --> commPub : approval given
    commPub --> TERM
    sFP --> CANC
    sFP --> LIT
    sFA : sFA
    state "failure_to_approve" as sFA
    sFA --> LIT
    sFA --> CANC
    inLic --> Obl6 : Comments_Published_Outside_License_Period
    NObl4 --> Obl6 : published_unapproved
    %% (or outside LP)
    Obl3 --> Obl6 : published_unapproved
    Obl5BrLic : Obl5BrLic
    state "Obligation_to_pay_breach_fee (brLic)" as Obl5BrLic
    Obl5BrLic --> TERM : breach fee paid
    Obl5BrLic --> TERM
    Obl5BrLic --> LIT
    Obl6 : Obl6
    state "Obligation_to_Remove_Comments" as Obl6
    Obl6 --> sFR : Healing_time_lapsed
    waitAppr : waitAppr
    state "Waiting_for_Approval 😀" as waitAppr
    waitAppr --> Obl3
    waitAppr --> sFA : approval overdue
    sUP --> Obl5BrLic
    sFP --> Obl5BrLic
    sFA --> Obl5BrLic
    sFR --> Obl5BrLic

