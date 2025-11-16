-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    state.OffenseMode:options('Normal', 'Acc', 'STP', 'TP', 'ZANISH', 'DOUBLE','CRIT')
	state.HybridMode:options('Normal','DT')
	state.RangedMode:options('Normal','Acc')
    state.WeaponskillMode:options('Normal', 'PDL', 'SC', 'vagary')
    state.CastingMode:options('Normal','SIRD')
    state.IdleMode:options('Normal', 'Evasion', 'PDT', 'MDT', 'Regen', 'HP', 'EnemyCritRate')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'HP', 'Enmity')
	state.MagicalDefenseMode:options('MDT')
	state.ResistDefenseMode:options('MEVA')
	state.Weapons:options('Heishi','None','Tauret','Naegling','Hachimonji','Zanmato','CLUB','H2H','ProcGreatSword','ProcScythe','ProcPolearm','ProcKatana','ProcDagger','ProcDagger2','ProcGreatKatana','ProcGreatKatana2','ProcSword','ProcSword2','ProcClub','ProcStaff','ProcStaff2')
	state.ExtraMeleeMode = M{['description']='Extra Melee Mode', 'None','SuppaBrutal','DWEarrings','DWMax'}

	gear.wsd_jse_back = {}
	gear.da_jse_back = {}    

    swordList = S{'Naegling'}
    GKList = S{'Hachimonji','Zanmato +1'}
    daggerList = S{'Tauret'}
    katanaList = S{'Heishi Shorinken','Kunimitsu'}

	send_command('bind ^` input /ja "Innin" <me>')
	send_command('bind !` input /ja "Yonin" <me>')
    send_command('bind !5 gs c toggle stance')
	send_command('bind @` gs c cycle SkillchainMode')
	send_command('bind !0 gs c set WeaponskillMode Proc;;gs c set CastingMode Proc;gs c update')
	send_command('bind !9 gs c weapons Default;gs c set WeaponskillMode Normal;gs c set CastingMode Normal;gs c update')
    
    send_command('bind f2 gs c toggle AutoShadowMode')

	utsusemi_cancel_delay = .3
	utsusemi_ni_cancel_delay = .06

	select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    -- Weapons sets
    sets.weapons.Normal = {}

    sets.weapons.Heishi = {main="Heishi Shorinken", sub="Kunimitsu"}
    sets.weapons.Tauret = {main="Tauret", sub="Kunimitsu"}
    sets.weapons.Naegling = {main="Naegling", sub="Kunimitsu"}
    sets.weapons.Hachimonji = {main="Hachimonji", sub="Alber Strap",}
    sets.weapons.Zanmato = {main="Zanmato +1",sub="Sword Strap",}
    sets.weapons.CLUB = {main="Mafic Cudgel",sub="Kunimitsu",}
    sets.weapons.H2H = {main="Karambit"}

	sets.weapons.ProcDagger = {main="Qutrub Knife",sub=empty}
    sets.weapons.ProcDagger2 = {main="Qutrub Knife",sub=empty}
	sets.weapons.ProcSword = {main="Fermion Sword",sub=empty}
    sets.weapons.ProcSword2 = {main="Fermion Sword",sub=empty}
	sets.weapons.ProcGreatSword = {main="Irradiance Blade",sub=empty}
	sets.weapons.ProcScythe = {main="Maven's Scythe",sub=empty}
	sets.weapons.ProcPolearm = {main="Sha Wujing's La. +1",sub=empty}
	sets.weapons.ProcGreatKatana = {main="Zanmato +1",sub=empty}
    sets.weapons.ProcGreatKatana2 = {main="Zanmato +1",sub=empty}
	sets.weapons.ProcKatana = {main="Debahocho +1",sub=empty}
	sets.weapons.ProcClub = {main="Caduceus",sub=empty}
	sets.weapons.ProcStaff = {main="Profane Staff",sub=empty}
    sets.weapons.ProcStaff2 = {main="Profane Staff",sub=empty}

    --------------------------------------
    -- Precast sets
    --------------------------------------

    sets.Enmity = {ammo="Paeapua",
        head="Dampening Tam",neck="Unmoving Collar +1",ear1="Friomisi Earring",ear2="Trux Earring",
        body="Emet Harness +1",hands="Kurys Gloves",ring1="Petrov Ring",ring2="Vengeful Ring",
        back="Moonlight Cape",waist="Goading Belt",legs="Nyame Flanchard",feet="Amm Greaves"}

    -- Precast sets to enhance JAs
    sets.precast.JA['Mijin Gakure'] = { legs="Mochizuki Hakama +3" }
    sets.precast.JA['Futae'] = { hands="Hattori Tekko +2" }
    sets.precast.JA['Sange'] = {body="Mochi. Chainmail +3"}
    sets.precast.JA['Innin'] = {head="Mochi. Hatsuburi +3"}
    sets.precast.JA['Yonin'] = {head="Mochi. Hatsuburi +3"}
    sets.precast.JA['Provoke'] = set_combine(sets.midcast.enmity , {
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    })
    sets.precast.JA['Warcry'] = sets.Enmity

    -- Waltz set (chr and vit)
    sets.precast.Waltz = { ammo="Yamarang",   
    head="Mummu Bonnet +2",
    body="Passion Jacket",
    legs="Dashing Subligar",}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = {
        head="Dampening Tam",neck="Moonbeam Nodowa",ear1="Mache Earring +1",ear2="Telos Earring",
        body="Mummu Jacket +2",hands="Adhemar Wrist. +1",
        back="Andartia's Mantle",waist="Olseni Belt",legs="Mummu Kecks +2",feet="Malignance Boots"}

    sets.precast.Flourish1 = {
        head="Dampening Tam",neck="Moonbeam Nodowa",ear1="Gwati Earring",ear2="Digni. Earring",
        body="Mekosu. Harness",hands="Adhemar Wrist. +1",
        back="Andartia's Mantle",waist="Olseni Belt",legs="Hattori Hakama +1",feet="Malignance Boots"}

    -- Fast cast sets for spells

    sets.precast.FC = {        ammo="Sapience Orb",
    head={ name="Herculean Helm", augments={'"Triple Atk."+4','STR+7','Accuracy+5','Attack+8',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Kishar Ring",
    neck="Orunmila's Torque", 
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket",feet="Hattori Kyahan +2"})
	sets.precast.FC.Shadows = set_combine(sets.precast.FC.Utsusemi, {ring1="Prolix Ring"})

    -- Snapshot for ranged
    sets.precast.RA = {
    ammo=empty,
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    }
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined

    -- Weaponskills 
    sets.precast.WS = {
        ammo="Yamarang",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Ishvara Earring",
        right_ring="Regal Ring",
        left_ring="Cornelia's Ring",
        back="Andartia's Mantle",
    }
        
    sets.precast.WS.SC = set_combine(sets.precast.WS, { 
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    sets.precast.WS.vagary =  {}
    sets.vagary =  {}

    sets.Kamu = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, sets.Kamu)
    sets.precast.WS['Blade: Kamu'].SC = set_combine(sets.precast.WS, sets.Kamu, {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},    })
    sets.precast.WS['Blade: Kamu'].PDL = set_combine(sets.precast.WS, sets.Kamu, {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring",     })
    
    -- BLADE: JIN
    sets.Jin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS, sets.Jin)
    sets.precast.WS['Blade: Jin'].SC = set_combine(sets.precast.WS['Blade: Jin'], {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Jin'].PDL = set_combine(sets.precast.WS['Blade: Jin'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},   
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},    
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    
    -- BLADE: HI
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Sacro Mantle",
    })
    sets.precast.WS['Blade: Hi'].SC = set_combine(sets.precast.WS['Blade: Hi'], {
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Hi'].PDL = set_combine(sets.precast.WS['Blade: Hi'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        legs={ name="Mpaca's Hose", augments={'Path: A',}},   
        right_ear="Hattori Earring +1", 
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring", 
    })
    
    -- BLADE: SHUN
    sets.Shun = {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Malignance Tabard",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Hattori Earring +1", 
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    
    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, sets.Shun)
    sets.precast.WS['Blade: Shun'].PDL = set_combine(sets.Shun, {
        ammo="Crepuscular Pebble",
        head="Malignance Chapeau",
        hands="Malignance Gloves",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},   
        feet="Malignance Boots",    
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},

    })
    sets.precast.WS['Blade: Shun'].SC = set_combine(sets.Shun, {
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Exenterator'] = set_combine(sets.Shun, {})
    sets.precast.WS['Viper Bite'] = set_combine(sets.Shun, {})

    
    -- BLADE: Rin
    sets.Rin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Rin'] = set_combine(sets.precast.WS, sets.Rin)
    sets.precast.WS['Blade: Rin'].SC = set_combine(sets.precast.WS.SC, sets.Rin)
    sets.precast.WS['Blade: Rin'].PDL = set_combine(sets.precast.WS['Blade: Rin'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},        
        right_ear="Hattori Earring +1", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    
    -- BLADE: KU 
    sets.Ku = {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Brutal Earring",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Ku'] = set_combine(sets.precast.WS, sets.Ku)
    sets.precast.WS['Blade: Ku'].SC = sets.precast.WS['Blade: Ku']
    sets.precast.WS['Blade: Ku'].PDL = set_combine(sets.precast.WS['Blade: Ku'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},       
        right_ear="Hattori Earring +1", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    
    sets.Ten = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
     neck="Rep. Plat. Medal",
     waist="Sailfi Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        back="Sacro Mantle",
    }
    
    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, sets.Ten)
    sets.precast.WS['Blade: Ten'].SC = set_combine(sets.precast.WS['Blade: Ten'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Ten'].PDL = set_combine(sets.precast.WS['Blade: Ten'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { 
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
     neck="Rep. Plat. Medal",
     waist="Sailfi Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        back="Sacro Mantle",
    })
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], { 
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    sets.precast.WS['Savage Blade'].SC = set_combine(sets.precast.WS['Savage Blade'], { 
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Savage Blade'],{})
    sets.precast.WS['Judgment'].PDL = set_combine(sets.precast.WS['Savage Blade'].PDL,{})


    sets.precast.WS.Evisceration = {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Odr Earring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle", 
    }
    sets.precast.WS.Evisceration.PDL = set_combine(sets.precast.WS.Evisceration, {
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })

    sets.precast.WS["True Strike"] = set_combine(sets.precast.WS.Evisceration, {})
    sets.precast.WS["True Strike"].PDL= set_combine(sets.precast.WS.Evisceration, {})

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring="Dingir Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        back="Sacro Mantle",
    })
    sets.precast.WS['Aeolian Edge'].vagary = {}
    sets.precast.WS['Aeolian Edge'].PDL = set_combine(sets.precast.WS['Aeolian Edge'],{
    --range="Wingcutter +1",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS['Aeolian Edge'], {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Nyame Helm", augments={'Path: B',}},
        neck="Fotia Gorget",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Friomisi Earring",
        left_ring="Cornelia's Ring",
        right_ring="Gere Ring",
    })
    sets.precast.WS['Tachi: Jinpu'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'], {
        --range="Wingcutter +1",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Tachi: Jinpu'].SC = set_combine(sets.precast.WS['Tachi: Jinpu'], {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Kagero'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Koki'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Goten'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {
    ammo="Pemphredo Tathlum",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back="Sacro Mantle",
    })

    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS['Aeolian Edge'], {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring="Gere Ring",
        back="Sacro Mantle",
       })
       
    sets.precast.WS['Blade: Chi'].PDL = set_combine(sets.precast.WS['Blade: Chi'], {
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+11','Accuracy+5','"Triple Atk."+2',}},
    })

    sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
    sets.precast.WS['Blade: Teki'].PDL = set_combine(sets.precast.WS['Blade: Chi'], {
    head="Genmei Kabuto",    
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Teki']
    sets.precast.WS['Blade: To'].PDL = sets.precast.WS['Blade: Teki'].PDL
    
    sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS, {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        back="Sacro Mantle",
    })
    sets.precast.WS['Blade: Yu'] = sets.precast.WS['Blade: Teki']
    sets.precast.WS['Blade: Yu'].PDL = sets.precast.WS['Blade: Yu'].PDL

    sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Archon Ring",
        right_ring="Cornelia's Ring",
        back="Sacro Mantle",
    })
       sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Asuran Fists'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS) 
       sets.precast.WS['Spinning Attack'].PDL= set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS) 
       sets.precast.WS['Backhand Blow'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Backhand Blow'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Shoulder Tackle'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Shoulder Tackle'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Combo'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS) 
       sets.precast.WS['Combo'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS) 

-- Elemental Weapon Skill --elemental_ws--

-- SANGUINE BLADE
-- 50% MND / 50% STR Darkness Elemental
sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Pixie Hairpin +1",
body={ name="Nyame Mail", augments={'Path: B',}},
hands={ name="Nyame Gauntlets", augments={'Path: B',}},
legs={ name="Nyame Flanchard", augments={'Path: B',}},
feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    right_ear="Friomisi Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Archon Ring",
    right_ring="Cornelia's Ring",
    back="Sacro Mantle",
})

sets.precast.WS["Dark Harvest"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Shadow of Death"] = set_combine(sets.precast.WS["Sanguine Blade"], {})

sets.precast.WS["Infernal Scythe"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Steal"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Drain"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS.Cataclysm = sets.precast.WS["Sanguine Blade"]

sets.precast.WS["Burning Blade"] = set_combine(sets.precast.WS, {
    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
body={ name="Nyame Mail", augments={'Path: B',}},
hands={ name="Nyame Gauntlets", augments={'Path: B',}},
legs={ name="Nyame Flanchard", augments={'Path: B',}},
feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ring="Cornelia's Ring",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ear="Friomisi Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    back="Sacro Mantle",
})

sets.precast.WS["Red Lotus Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Shining Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Seraph Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Cloudsplitter"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Primal Rend"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Cyclone"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Gust Slash"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Shining Strike"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Seraph Strike"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Flash Nova"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Thunder Thrust"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Raiden Thrust"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Frostbite"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Freezebite"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Herculean Slash"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Earth Crusher"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Rock Crusher"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Starburst"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Sunburst"] = set_combine(sets.precast.WS["Burning Blade"],{})
sets.precast.WS["Flaming Arrow"] = set_combine(sets.precast.WS["Burning Blade"],{})

sets.precast.WS["Shadow of Death"].vagary = sets.precast.WS.vagary
sets.precast.WS["Cyclone"].vagary =  {}
sets.precast.WS["Starburst"].vagary =  {}
sets.precast.WS["Sunburst"].vagary =  {}
sets.precast.WS["Earth Crusher"].vagary =  {}
sets.precast.WS["Freezebite"].vagary =  {}
sets.precast.WS["Red Lotus Blade"].vagary =  {}
sets.precast.WS["Seraph Blade"].vagary =  {}
sets.precast.WS["Energy Drain"].vagary =  {}
sets.precast.WS["Shining Blade"].vagary =  {}
sets.precast.WS["Raiden Thrust"].vagary =  {}
sets.precast.WS['Tachi: Jinpu'].vagary =  {}
sets.precast.WS['Tachi: Koki'].vagary =  {}

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Lugra Earring",ear2="Lugra Earring +1",}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.AccDayMaxTPWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayMaxTPWSEars = {ear1="Cessance Earring",ear2="Brutal Earring",}
	sets.AccDayWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayWSEars = {ear1="Moonshade Earring",ear2="Brutal Earring",}


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {}
    sets.SIRD = {
         sub="Tancho",
        ammo="Staunch Tathlum +1",
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        neck="Moonlight Necklace",
        waist="Audumbla Sash",
        left_ear="Halasz Earring",
        right_ring="Evanescence Ring",
        back="Moonlight Cape",
    }

    sets.midcast.ElementalNinjutsu = {        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands="Hattori Tekko +2",
legs={ name="Nyame Flanchard", augments={'Path: B',}},
feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
 left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
 right_ring="Dingir Ring",
 left_ear="Hecate's Earring",
 right_ear="Friomisi Earring",
 back="Argocham. Mantle",}

	sets.midcast.ElementalNinjutsu.Proc = sets.midcast.FastRecast

    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.ElementalNinjutsu, {})

	sets.MagicBurst = set_combine(sets.midcast.ElementalNinjutsu, { 
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Hattori Tekko +2",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Orpheus's Sash",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Mujin Band",
        back="Argocham. Mantle",})

    sets.midcast.NinjutsuDebuff = {        ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",}

    sets.midcast.NinjutsuBuff = set_combine(sets.midcast.FastRecast, { 
    neck="Incanter's Torque",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",})

    sets.midcast.Utsusemi = set_combine(sets.midcast.NinjutsuBuff, {
        feet="Hattori Kyahan +2",
        back="Andartia's Mantle",
    })

    sets.midcast.Migawari = set_combine(sets.midcast.Ninjutsu, {    neck="Incanter's Torque",
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
        back="Andartia's Mantle",
    })


    sets.midcast['Enhancing Magic'] = {
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Mendi. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
	}

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell


    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        neck="Stone Gorget",
        legs="Haven Hose",
        left_ear="Earthcry Earring",
        waist="Siegel Sash"})
        
    sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {
        body={ name="Herculean Vest", augments={'Phys. dmg. taken -1%','Accuracy+11 Attack+11','Phalanx +2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
        hands={ name="Herculean Gloves", augments={'Accuracy+11','Pet: Phys. dmg. taken -5%','Phalanx +4',}},
        feet={ name="Herculean Boots", augments={'Accuracy+8','Pet: Attack+28 Pet: Rng.Atk.+28','Phalanx +4','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
    })

    sets.midcast.Cure = {
        ammo="Pemphredo Tathlum",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Macabre Gaunt. +1", augments={'Path: A',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
        neck="Reti Pendant",
        waist="Plat. Mog. Belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Mendi. Earring",
        left_ring="Naji's Loop",
        right_ring="Defending Ring",
        back="Solemnity Cape",
	}

    sets.midcast.Absorb = {
        ammo="Pemphredo Tathlum",
        neck="Erra Pendant",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    }

    sets.midcast.RA = {
        ammo=empty,
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        left_ear="Crep. Earring",
        right_ear="Telos Earring",}

    sets.midcast.RA.Acc = {
        ammo=empty,
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        left_ear="Crep. Earring",
        right_ear="Telos Earring",}

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        body="Hiza. Haramaki +2",
        hands={ name="Rao Kote +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        legs={ name="Rao Haidate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        feet={ name="Rao Sune-Ate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
            neck={ name="Bathy Choker +1", augments={'Path: A',}},
            left_ear="Infused Earring",
            left_ring="Chirich Ring +1",
            right_ring="Chirich Ring +1",
    }

    -- Idle sets

--idle - defense

sets.idle = {
    ammo="Yamarang",
    head="Malignance Chapeau",
    body="Adamantite Armor",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    left_ear="Eabani Earring",
    right_ear="Infused Earring",
    left_ring="Vengeful Ring",
    right_ring="Hizamaru Ring",
    back="Andartia's Mantle",

}
sets.idle.PDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Paguroidea Ring",
    back="Moonlight Cape",
    }
sets.idle.MDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Shadow Ring",
    right_ring="Defending Ring",
    right_ring="Purity Ring",
    back="Moonlight Cape",
}
sets.idle.HP = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Adamantite Armor",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    right_ear="Tuisto Earring",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Eihwaz Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
    ammo="Eluder's Sachet",
    left_ring="Warden's Ring",
    right_ring="Fortified Ring",
    back="Reiki Cloak",
})
sets.idle.Regen = set_combine(sets.idle, {
    head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    body="Hizamaru Haramaki +2",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    ear2="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    })

sets.idle.Sphere = set_combine(sets.idle, {body="Mekosu. Harness"})
sets.idle.Evasion = {
    ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    left_ear="Eabani Earring",
    right_ear="Infused Earring",
    left_ring="Vengeful Ring",
    right_ring="Hizamaru Ring",
    back="Moonlight Cape",
}



    -- Defense sets
    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Paguroidea Ring",
        back="Moonlight Cape",
        }
        sets.defense.Enmity = {
            ammo="Iron Gobbet",
            head="Malignance Chapeau",
            body={ name="Emet Harness +1", augments={'Path: A',}},
            hands="Kurys Gloves",
            legs={ name="Zoar Subligar +1", augments={'Path: A',}},
            feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
            neck={ name="Unmoving Collar +1", augments={'Path: A',}},
            waist="Flume Belt +1",
            left_ear="Trux Earring",
            right_ear="Cryptic Earring",
            left_ring="Defending Ring",
            right_ring="Vengeful Ring",
            back="Reiki Cloak",
        }
        sets.defense.HP = {
            ammo="Coiste Bodhar",
            head={ name="Nyame Helm", augments={'Path: B',}},
            body="Adamantite Armor",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck={ name="Unmoving Collar +1", augments={'Path: A',}},
            waist="Plat. Mog. Belt",
            right_ear="Tuisto Earring",
            left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
            left_ring="Eihwaz Ring",
            right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
            back="Moonlight Cape",
        }
        sets.defense.MDT = set_combine(sets.defense.PDT, {
            ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
            waist="Carrier's Sash",
            left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
            right_ear="Tuisto Earring",
            left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
            right_ring="Purity Ring",
            back="Moonlight Cape",
        })
        sets.defense.Evasion = sets.idle.Evasion
    
	sets.defense.MEVA = { ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Engraved Belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Purity Ring",
        back="Moonlight Cape",}


    sets.Kiting = {feet="Danzo Sune-Ate"}
	sets.DuskKiting = {}
	sets.DuskIdle = {}
	sets.DayIdle = {}
	sets.NightIdle = {}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    
    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Windbuffet Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        right_ring="Gere Ring",
        left_ring="Epona's Ring",
        back="Andartia's Mantle",
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo="Yamarang",
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        left_ear="Crep. Earring",
        ear2="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        waist="Olseni Belt",
    })
    sets.engaged.TP = {
        ammo="Coiste Bodhar",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Windbuffet Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        right_ring="Gere Ring",
        left_ring="Epona's Ring",
        back="Andartia's Mantle",
    }
    sets.engaged.STP = set_combine(sets.engaged, {
        ammo="Aurgelmir Orb +1",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        waist={ name="Kentarch Belt +1", augments={'Path: A',}},
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    })
    sets.engaged.ZANISH = set_combine(sets.engaged, {
        ammo="Aurgelmir Orb +1",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs="Ryuo Hakama +1",
        feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Sailfi Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    })
    sets.engaged.DOUBLE = set_combine(sets.engaged,{
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Clotharius Torque",
        waist="Sailfi Belt +1",
        left_ear="Balder Earring +1",
        right_ear="Cessance Earring",
        right_ring="Gere Ring",
        left_ring="Epona's Ring",
        back="Andartia's Mantle", 
    })
    sets.engaged.CRIT = {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamash. +2",
        neck="Nefarious Collar +1",
        waist="Gerdr Belt",
        left_ear="Brutal Earring",
        right_ear="Odr Earring",
        left_ring="Mummu Ring",
        right_ring="Hetairoi Ring",
        back="Andartia's Mantle",
    }


------------------------------------------------------------------------------------------------
    ---------------------------------------- DW ------------------------------------------
------------------------------------------------------------------------------------------------
    -- * NIN Native DW Trait: 35% DW

    -- No Magic Haste (74% DW to cap)

    sets.engaged.DW = {
        ammo="Seki Shuriken",
        head="Ryuo Somen +1", --9
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet="Malignance Boots",
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Sailfi Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        right_ring="Gere Ring",
        left_ring="Epona's Ring",
        back="Andartia's Mantle",
    }
    
    sets.engaged.DW.Acc = set_combine(sets.engaged, {
        ammo="Seki Shuriken",
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        left_ear="Crep. Earring",
        ear2="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        waist="Olseni Belt",
    })
    sets.engaged.DW.STP = set_combine(sets.engaged, {
        ammo="Seki Shuriken",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        waist="Gerdr Belt",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
        })
    
    sets.engaged.DW.CRIT =  {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamash. +2",
        neck="Nefarious Collar +1",
        waist="Gerdr Belt",
        left_ear="Brutal Earring",
        right_ear="Odr Earring",
        left_ring="Mummu Ring",
        right_ring="Hetairoi Ring",
        back="Andartia's Mantle",
    }
    
    ------------------------------------------------------------------------------------------------
---------------------------------------- Hybrid Sets -------------------------------------------
------------------------------------------------------------------------------------------------

sets.engaged.Hybrid = {
    head="Malignance Chapeau", --6/6
    body="Malignance Tabard", --9/9
    hands="Malignance Gloves", --5/5
    legs="Malignance Tights", --7/7
    feet="Malignance Boots", --4/4
    --ring2="Defending Ring", --10/10
}

sets.engaged.DT = set_combine(sets.engaged, {
    head="Malignance Chapeau", --6/6
    body="Malignance Tabard", --9/9
    hands="Malignance Gloves", --5/5
    legs="Malignance Tights", --7/7
    feet="Malignance Boots", --4/4
    --ring2="Defending Ring", --10/10
})
sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)
sets.engaged.CRIT.DT = set_combine(sets.engaged.CRIT, sets.engaged.Hybrid)



sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT = set_combine(sets.engaged.DW.CRIT, sets.engaged.Hybrid)
    --------------------------------------
    -- Custom buff sets
    --------------------------------------


------------------------------------------------------------------------------------------------
---------------------------------------- Special Sets ------------------------------------------
------------------------------------------------------------------------------------------------
    
sets.buff.Migawari = {     neck="Incanter's Torque",
feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
left_ring="Stikini Ring +1",
right_ring="Stikini Ring +1",
back="Andartia's Mantle",
}
    
    sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}
    
    --sets.buff.Doom = set_combine(sets.buff.Doom, {})
	sets.buff.Futae = {}
    sets.buff.Yonin = {} --
    sets.buff.Innin = {} --head="Hattori Zukin +1"

    -- Extra Melee sets.  Apply these on top of melee sets.
    sets.Knockback = {}
	sets.SuppaBrutal = {ear1="Suppanomimi", ear2="Brutal Earring"}
	sets.DWEarrings = {    left_ear="Suppanomimi", --5
    right_ear="Eabani Earring", --4
    }
	sets.DWMax = {  head="Ryuo Somen +1", --9
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    feet="Hiza. Sune-Ate +2", --8
    left_ear="Suppanomimi",  --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
    }
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {
    ammo="Per. Lucky Egg", head="Wh. Rarab Cap +1",
    waist="Chaac Belt"
    })
	sets.Skillchain = {legs="Ryuo Hakama +1",}


end
function user_job_lockstyle()
	windower.chat.input('/lockstyleset 144')
end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(3, 27)
    elseif player.sub_job == 'RNG' then
        set_macro_page(8, 27)
    elseif player.sub_job == 'RDM' then
        set_macro_page(8, 27)
    elseif player.sub_job == 'DNC' then
        set_macro_page(1, 27)
    elseif player.sub_job == 'RUN' then
        set_macro_page(8, 27)
    else
        set_macro_page(8, 27)
    end
end

autows_list = {['Default']='Blade: Shun',['Tauret']='Aeolian Edge',['ProcGreatSword']='Freezebite',['ProcScythe']='Shadow of Death',['ProcDagger2']='Cyclone',['ProcDagger']='Energy Drain',['ProcStaff2']='Sunburst',['ProcStaff']='Earth Crusher',['ProcSword2']='Seraph Blade',['ProcSword']='Red Lotus Blade',['ProcGreatKatana']='Tachi: Jinpu',['ProcGreatKatana2']='Tachi: Koki',['ProcKatana']='Blade: Ei',['ProcPolearm']='Raiden Thrust',['DualSavageWeapons']='Savage Blade',['DualEvisceration']='Evisceration',['DualLeadenRanged']='Leaden Salute',['DualLeadenMelee']='Leaden Salute',['DualAeolian']='Aeolian Edge',['DualRanged']='Last Stand'}
