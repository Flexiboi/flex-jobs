local Translations = {
    success = {
        clockedin = 'Gestart met werken.',
        successended = 'Goed gedaan! Blije klanten zo te zien aan de reviews!',
        rep = 'Je kreeg %{value} reputatie bij WashiWash.',
        earn = 'Je verdiende €%{value} voor het wassen!'
    },
    error = {
        cantworkhere = 'Mensen zoals jouw mogen hier niet werken!',
        clockedout = 'Gestopt met werken.',
        earlyclockout = 'Je verloor rep door vroegtijdig te stoppen met werken..',
        rep = 'Je verloor %{value} reputatie bij WashiWash.',
    },
    notify = {
        header = 'WashieWash',
        startmsg = 'Gestart met werken!',
        pickedupcar = 'Auto opgehaald en klaar om te werken!',
        cleaned = 'Raam gewassen! Nog %{value} te gaan..',
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
        carnotfound = 'Is je werkauto hier wel?',
    },
    blip = {
        window = 'Raam',
        dropoff = 'Garage'
    },
    command = {
        help = 'Check je cleaning rep',
        rep = 'Je hebt %{value} reputatie bij WashieWash.',
    },
    progress = {
        cleaning = 'Raam proper maken..',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
