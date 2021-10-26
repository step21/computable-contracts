stateDiagram-v2
    q0 : q0
    state "Offer_Open 😀" as q0
    q1: q1
    %% replace events with shorthand / short ids
    %% sublicense omitted
    state "Accepted Offer 😀" as q1
    [*] --> q0
    q0 --> q1
    q1 --> acCo : signed
    acCo : acCo
    state "active Contract 😀" as acCo
    Obl1 : Obl1
    state "Obligation_to_pay_license_fee and grant license 😀" as Obl1
    acCo --> Obl1 : payment invoice and license requested
    Obl1 --> sFL : failure to license
    %%Obl1 --> acCo : payment
    Obl1 --> sUP : failure to pay
    Obl1 --> inLic : payment made and license granted
    inLic --> acLic : license start date passes
    sUP: sUP
    sUP --> LIT
    sFL --> LIT
    sFL --> CANC
    %%Canceled due being past the statute of limitations or by mutual agreement
    sUP --> CANC : canceled past statute of limitations or by agreement
    sFL : sFL
    state "Failure_to_license" as sFL
    state "Failed obligation to pay" as sUP
    sFL --> CANC : canceled past statute of limitations or by agreement
    sFR --> LIT
    %%Legal action/dispute resolution / arbitration_state
    %% for DFA - also remove forks.
    sFR : sFR
    state "Failed obligation to remove" as sFR
    %% should breached license be replaced by specific breaches? Or be removed
    brLic : brLic
    state "Breached_License" as brLic
    acCo --> brLic
    %%state license_start <<fork>>
    inLic : inLic
    state "Inactive_License" as inLic
    acLic --> inLic : license period ends
    %%acCo --> license_start
    acCo --> TERM
    acLic : acLic
    %% style acLic "fill:#f9f,stroke:#333,stroke-width:4px"
    state "Active_License 😀" as acLic
    %%inLic --> acLic
    %%acCo --> acLic
    %% if DFA, this should prob not go from acCo to inLic and either is implicit or should go from some failure state?
    %%acCo --> inLic
    %% connect sublicenses in/active to failures or somehow move inactive sublicenses? are they needed? are they a state?
    acSublic : acSublic
    state "Active_Sublicenses" as acSublic
    acLic --> acSublic
    %% specify time for remedy
    
    acLic --> Obl6 : Non_Approved_Comments_Published
    %%state commissioned <<fork>>
    %%acLic --> commissioned
    Obl3 : Obl3
    state "Obligation_to_Publish 😀" as Obl3
    NObl4 : NObl4
    state "No_obligation_to_publish 😀" as NObl4
    acLic --> Obl3 : check_commissioned
    acLic --> NObl4
    %% also unclear in text if commissioned also has to submit for approval
    %% could prob go to waiting for approval directly? Yes!
    NObl4 --> waitAppr : comments within LP
    NObl4 --> TERM
    %%state pub_or_no_pub <<choice>>
    %%Obl3 --> pub_or_no_pub
    Obl3 --> waitAppr : comments submitted
    %%pub_or_no_pub --> commSub
    %% this would need actually a specification of time, when it is a failure.
    sFP : sFP
    state "Failure_to_Publish" as sFP
    Obl3 --> sFP : commissioned, end of license w/o comments
    commPub : commPub
    state "Comments_Published 😀" as commPub
    %% also acLic to inLic and inLic to TERM?
    %% or event instead of state license period ended ?
    waitAppr --> commPub : approval given
    commPub --> TERM
    sFP --> CANC
    sFP --> LIT
    sFA : sFA
    state "failure_to_approve" as sFA
    sFA --> LIT
    sFA --> CANC
    inLic --> Obl6 : Comments_Published_Outside_License_Period
    acLic --> brLic
    % Default or what would be the correct end state
    acSublic --> brLic
    # should go from obligation to publish / not obligation to Non approved comments published etc.
    NObl4 --> Obl6 : published_unapproved
    %% (or outside LP)
    Obl3 --> Obl6 : published_unapproved
    Obl5 : Obl5
    state "Obligation_to_pay_breach_fee" as Obl5
    brLic --> Obl5
    %%Obl5 --> Default
    Obl5 --> TERM
    Obl5 --> LIT
    Obl6 : Obl6
    state "Obligation_to_Remove_Comments" as Obl6
    Obl6 --> sFR : Healing_time_lapsed
    waitAppr : waitAppr
    state "Waiting_for_Approval 😀" as waitAppr
    waitAppr --> Obl3
    waitAppr --> sFA : approval overdue
    #clean up end states
    # check if everything is really a state

