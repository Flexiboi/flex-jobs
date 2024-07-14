local Translations = {
    success = {
        clockedin = 'Gestart met werken.',
        successended = 'Goed gedaan! Blije klanten zo te zien aan de reviews!',
        rep = 'Je kreeg %{value} reputatie bij de manne/vrouwen van de elektriciteit.',
        earn = 'Je verdiende €%{value} voor deze kast.'
    },
    error = {
        cantworkhere = 'Ga weg jij corrupte persoon!',
        canceled = 'Oeps, wat doe je nu?',
        clockedout = 'Gestopt met werken.',
        earlyclockout = 'Je verloor rep door vroegtijdig te stoppen met werken..',
        rep = 'Je verloor %{value} reputatie bij de manne/vrouwen van de elektriciteit.',
        cabinalreadyfiued = 'Deze kast is al gemaakt..',
    },
    notify = {
        header = 'Elektriciteit',
        startmsg = 'Gestart met werken!',
        pickedupcar = 'Auto opgehaald en klaar om te werken!',
        repaired = 'Kast genaakt! Nog %{value} te gaan..',
        repairedfinish = 'Zizo, je werk zit er op voor vandaag!',
    },
    menu = {
        readytowork = 'Klaar om te werken?',
        titel1 = 'Start met werken',
        titel2 = 'Stop met werken',
        titel3 = 'Check je reputatie',
    },
    info = {
        dropoffveh = 'Lever auto in',
        dropoffblip = 'Garage',
        carnotfound = 'Heb je wel je werkvoertuig bij?',
    },
    command = {
        help = 'Check je elektriciteit rep',
        rep = 'Je hebt %{value} reputatie bij de manne/vrouwen van de elektriciteit.',
    },
    target = {
        work = 'Werk aan kast',
    },
    progress = {
        repairing = 'Kast aan het herstellen..',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
