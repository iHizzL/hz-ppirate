local Translations = {
    notify = {
        ["test"] = "Dette er det som vises",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

--Lang:t('notify.test')