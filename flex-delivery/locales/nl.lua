local Translations = {
    success = {
        clockedin = 'Gestart met werken.',
        successended = 'Goed gedaan! Blije klanten zo te zien aan de reviews!',
        rep = 'Je kreeg %{value} reputatie bij Pakiedoe.',
        earn = 'Je verdiende €%{value} voor je levering!',
    },
    error = {
        cantworkhere = 'Ik vertrouw je niet.. Wegwezen!',
        clockedout = 'Gestopt met werken.',
        earlyclockout = 'Je verloor rep door vroegtijdig te stoppen met werken..',
        rep = 'Je verloor %{value} reputatie bij Pakiedoe.',
    },
    notify = {
        header = 'Pakiedoe',
        startmsg = 'We hebben een job voor je! Neem snel je busje en kijk op je gps.'
    },
    pickup = {
        info = {
            takebox = 'Pak doos op',
            godeliver = 'Top, dat zijn alle pakjes. Nu snel gaan leveren!',
        },
        blip = 'Ophalen',
    },
    dropoff = {
        info = {
            deliverbox = 'Lever doos af',
            nextdropoff = 'Pakje afgeleverd. Kijk op je gps voor het volgende adres.',
            finishdropoff = 'Pakjes afgeleverd. Ga nu je auto inleveren.',
        },
        blip = 'Leveren',
    },
    deliver = {
        blip = 'Bezorgadres',
    },
    blip = {
        dropoff = 'Garage',
    },
    info = {
        checkrep = 'Check je reputatie',
        dropoffveh = 'Voertuig inleveren',
        carnotfound = 'Is je werkvoertuig wel hier?'
    },
    target = {
        readytowork = 'Klaar om te werken?',
        startjob = 'Start met werken',
        stopjob = 'Stop met werken',
    },
    command = {
        help = 'Check je delivery rep',
        rep = 'Je hebt %{value} reputatie bij Pakiedoe.',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
