local Translations = {
    success = {
        clockedin = 'Gestart met werken.',
        successended = 'Goed gedaan! Blije klanten zo te zien aan de reviews!',
        rep = 'Je kreeg %{value} reputatie bij vuilnis.',
        earn = 'Je kreeg €%{value} voor deze zak'
    },
    error = {
        cantworkhere = 'Personen zoals jij, mogen hier niet werken!',
        clockedout = 'Gestopt met werken.',
        earlyclockout = 'Je verloor rep door vroegtijdig te stoppen met werken..',
        rep = 'Je verloor %{value} reputatie bij vuilnis.',
        garbagebinempty = 'Deze vuilbak is leeg..',
    },
    notify = {
        header = 'Vuilnis',
        startmsg = 'Gestart met werken!',
        pickedupcar = 'Auto opgehaald en klaar om te werken!',
        cleaned = 'Vuil opgehaald! Nog %{value} te gaan..',
        cleanfinish = 'Zizo, je werk zit er op voor vandaag!',
    },
    menu = {
        readytowork = 'Klaar om te werken?',
        titel1 = 'Start met werken',
        titel2 = 'Stop met werken',
        titel3 = 'Check je reputatie',
    },
    info = {
        dropoffveh = 'Lever auto in',
        carnotfound = 'Is je vuilniswagen wel hier?',
    },
    blip = {
        garbagezone = 'Ophaalgebied',
        dropoff = 'Garage'
    },
    command = {
        help = 'Check je vuilnis rep',
        rep = 'Je hebt %{value} reputatie bij vuilnis.',
    },
    target = {
        grabgarbage = 'Neem vuilniszak',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
