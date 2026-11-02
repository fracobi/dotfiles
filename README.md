# fracobi/dotfiles

Configurazione personale Fedora 44 KDE + Hyprland (Lua), Noctalia/Quickshell,
Kitty, Zsh/Starship e GNU Stow.

**Stato:** desktop verificato in VM dopo la build aggiuntiva del runtime;
ripristino dell’intero sistema ancora da completare. Vedere il
[test reale in VM e le schermate](docs/vm-test/README.md) e
[l’audit con dipendenze mancanti e soluzioni](docs/REPLICATION.md)
prima di installare. Non è un'immagine del disco né un backup dei dati.

```bash
sudo dnf install git
git clone --recurse-submodules https://github.com/fracobi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap-fedora.sh
```

Il bootstrap Fedora installa le dipendenze del manifest e configura i COPR
`sdegler/hyprland` e `errornointernet/quickshell`. Richiede il runtime
`noctalia-qs` compatibile prima di applicare le configurazioni: la build locale
attuale si può compilare con `./scripts/install-noctalia-qs-fedora.sh`, quindi
rieseguire il bootstrap. Vedere l'audit per gli altri blocchi.

Per sole configurazioni, dopo aver installato le dipendenze:

```bash
./install.sh --dry-run
./install.sh
./scripts/check-setup.sh
```

Stow conserva i file nel clone e crea link in HOME. Non spostare/eliminare il clone.
I conflitti sono salvati per file in `~/.local/state/dotfiles/backups/`.
La simulazione segnala conflitti senza modificarli. Nessun servizio viene
abilitato automaticamente. È possibile usare una HOME di prova:
`./install.sh /percorso/home-di-prova`.

`inventory/` fotografa pacchetti, versioni, Flatpak e repository della macchina
sorgente; `packages/fedora.txt` è invece il manifest desktop da mantenere.
Account, segreti, modelli AI, sfondi, dati e driver specifici richiedono procedure
separate. Gli script Arch/CachyOS sono conservati come materiale storico e non
sono il percorso supportato o verificato.
