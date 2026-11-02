# fracobi/dotfiles

Setup personale Fedora 44 KDE + Hyprland Lua, Noctalia, Kitty e Zsh/Starship.
Il flusso previsto è: installare Fedora, applicare la repo, completare dati,
account e strumenti personali con la [checklist di migrazione](docs/MIGRATION.md).

```bash
sudo dnf install git
git clone --recurse-submodules https://github.com/fracobi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap-fedora.sh
```

Il bootstrap installa le dipendenze desktop, Brave dal repository ufficiale,
Starship dal COPR, Atuin, Matugen, screenshot e font Nerd con checksum fissato.
Se necessario compila il runtime Noctalia al commit verificato nella VM.
Al login selezionare **Hyprland (uwsm-managed)**.

```bash
./scripts/check-setup.sh          # base obbligatoria e promemoria opzionali
./scripts/check-setup.sh --strict # richiede anche i componenti opzionali
```

Monitor automatici su una macchina nuova; personalizzazioni in
`~/.config/hypr/local.lua`, escluso da Git e Stow. Il vecchio assetto monitor
rimane selezionabile con il profilo `current`. I percorsi Noctalia vengono
adattati al nuovo HOME durante l'installazione.

Per applicare solo le configurazioni con GNU Stow:

```bash
./install.sh --dry-run
./install.sh
```

Conservare il clone: i file sono collegati da quella cartella. I conflitti
vengono salvati per file in `~/.local/state/dotfiles/backups/`. Su una HOME diversa
i file che richiedono percorsi personali diventano copie locali. Nessun servizio
personale di sincronizzazione viene abilitato automaticamente.

- [Checklist operativa: cosa finire e come](docs/MIGRATION.md)
- [Test reale in VM, schermate e limiti](docs/vm-test/README.md)
- [Audit iniziale e problemi rilevati](docs/REPLICATION.md)
- `inventory/`: fotografia del vecchio sistema, da consultare per scegliere le app;
  non è una lista da reinstallare alla cieca.

Supporto di riferimento: Fedora 44 tradizionale, KDE, x86_64. Atomic/Kinoite e altre
release non sono verificate. Gli script Arch/CachyOS restano materiale storico.
Driver, dati, modelli AI, account, PWA e credenziali richiedono completamento
manuale. La repo non è un'immagine del disco né un backup dei dati personali.
