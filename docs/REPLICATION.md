# Audit e ripristino — 2 novembre 2026

## Verdetto

La repo originale non replicava il sistema completo. Installava solo Arch/CachyOS;
`packages/fedora.txt` era incompleto e non usato. Il README dichiarava Fedora
senza una procedura corrispondente. Ora Fedora 44 tradizionale, preferibilmente
KDE come il PC di origine, è il riferimento. Atomic/Kinoite non è supportato.
La procedura aggiornata resta un punto di partenza, NON un ripristino completo.
È stato eseguito un [collaudo reale in VM](vm-test/README.md): desktop funzionante
dopo la build aggiuntiva del runtime, con dipendenze ancora mancanti.

## Cosa è stato riallineato

Le configurazioni Hyprland, Kitty, Noctalia, Quickshell, Zsh e temi sono già
collegate tramite Stow alla copia locale della repo. Le modifiche preesistenti
sono state preservate. Inclusi i nuovi script screenshot e monitor presenti
nella cartella, tre script locali per dettatura/tastiera, il suono notifiche,
configurazioni cava/fontconfig e unità desktop systemd mancanti dall'installazione.
Il vecchio pacchetto `systemd` rimane come riferimento: include un override
rclone specifico della macchina e non viene applicato automaticamente.

L'installer ora salva singoli file in conflitto in
`~/.local/state/dotfiles/backups/<data>-<pid>/`, gestisce anche GTK4, Qt6 e
Starship attraverso i pacchetti, include i servizi desktop ed esclude backup.
Non abilita servizi automaticamente. I link Stow richiedono di conservare il clone.

## Blocchi e soluzioni, in ordine

1. **Runtime Quickshell speciale.** `qs --version` sul PC sorgente restituisce
   `noctalia-qs 0.0.12`, revisione `f308426239665e3bc3d624014e9295b2ae2f58ff`;
   `/usr/local/bin/qs` punta a un binario compilato localmente, non gestito da RPM.
   Il bootstrap si ferma prima di applicare le configurazioni se manca questo
   runtime. Ora `scripts/install-noctalia-qs-fedora.sh` compila dal repository
   pubblico `noctalia-dev/noctalia-qs` il commit esatto: build riuscita nella VM
   Fedora 44 con Qt 6.11.2. Rimane da mantenere la compatibilità negli aggiornamenti. Non assumere compatibilità del pacchetto
   `quickshell-git`: upstream documenta quel pacchetto per Fedora, ma non è
   necessariamente il fork attualmente usato.
   Fonte: https://quickshell.org/docs/v0.3.2/guide/install-setup/
2. **Hyprland e plugin.** Origine: RPM `hyprland-0.56.2-2.fc44.x86_64`,
   configurazione Lua e layout scrolling. Servono versione/API compatibili;
   Fedora da sola non garantisce questo. COPR osservato: `sdegler/hyprland`.
   `hyprpm reload` e `scrolloverview` sono configurati ma manca una ricetta che
   registri e compili i plugin. Salvare URL/revisioni plugin e provarli insieme
   alla versione Hyprland; evitare aggiornamenti indipendenti non collaudati.
   Build Fedora 44: https://copr-be.cloud.fedoraproject.org/results/sdegler/hyprland/fedora-44-x86_64/
3. **Programmi fuori da RPM.** Starship 1.24.2 e Atuin 18.12.1 sono in
   `~/.cargo/bin`; `spf`, yazi, matugen e wvkbd sono installazioni locali.
   `~/.local/bin/hyprshot` risulta un collegamento non risolvibile nel contesto
   dell'audit. Servono ricette/versioni per questi strumenti; prima di migrare
   verificare ogni comando con `command -v`. Brave richiede il suo repository.
   Non è incluso nel bootstrap e resta una dipendenza della configurazione.
   Aggiungere un manifest separato per Cargo, binari e repository esterni.
4. **Dettatura.** Gli script sono inclusi, ma richiedono
   `~/.local/share/whisper.cpp/build/bin/whisper-cli`, modello in
   `~/.local/share/applications/waystt/models/` e parametri in
   `~/.config/waystt/.env`. Non sono stati copiati modelli o file .env.
   Creare un installer opzionale con sorgenti/versione e checksum modello,
   più un esempio pubblico dei soli parametri non segreti.
5. **Percorsi e hardware.** Restano riferimenti `/home/cobi`, `/mnt/windows`,
   monitor `eDP-1`/`HDMI-A-1`, risoluzioni, workspace, foto e sfondi esterni.
   Rofi ha una configurazione esterna non inclusa. Alcune PWA Brave usano ID
   legati al profilo. Separare un profilo hardware locale da quello comune,
   usare HOME/XDG dove supportato e un fallback monitor automatico. Non sono
   state riscritte in massa le configurazioni attive, per preservare il setup.
6. **Servizi e dati privati.** Rclone, timer, progetti personali, mount Windows,
   impostazioni KDE, account, SSH/GPG, pairing KDE Connect e profili browser
   non sono ripristinati. Usare backup cifrato separato per dati e credenziali;
   ricette esplicite per mount, sync e servizi progetto. Non pubblicare .env,
   rclone.conf, token, chiavi o sessioni. Non abilitare sync sulla macchina nuova
   prima di verificare percorsi e remoti.
7. **Sistema e applicazioni.** Driver GPU, Secure Boot, partizioni, bootloader,
   codec, stampanti e applicazioni non sono coperti dai dotfiles.
   `inventory/` contiene RPM con e senza versioni, app Flatpak/origini e nomi
   repository abilitati del PC sorgente: è materiale di confronto, non una
   lista da installare alla cieca (include dipendenze, driver e pacchetti locali).
   Separare app desiderate, sviluppo e componenti hardware in manifest opzionali.
   I cinque Flatpak elencati possono essere reinstallati da Flathub dopo aver
   configurato il remoto; non comprende dati o preferenze delle applicazioni.
8. **Backup già tracciati.** Due file `.bak` erano già versionati (Kitty e una
   traduzione pomodoro); ignorarli non li rimuove dalla cronologia. Sono esclusi
   da Stow. Valutare rimozione dal tracking in una pulizia successiva.

## Procedura nuova macchina

1. Installare Fedora 44 KDE tradizionale, aggiornare e verificare GPU/rete.
2. Clonare ricorsivamente la repo e leggere questo audit.
3. Eseguire `./bootstrap-fedora.sh`: configura i due COPR esplicitati e installa
   le dipendenze elencate; chiede le normali conferme DNF. La disponibilità dei
   pacchetti e delle dipendenze COPR va verificata sulla macchina destinazione.
4. Risolvere il blocco noctalia-qs e le dipendenze esterne sopra, quindi rieseguire.
5. Eseguire `./scripts/check-setup.sh`, adattare percorsi e monitor, verificare
   con `./install.sh --dry-run`; per applicare usare `./install.sh`.
6. Eseguire `systemctl --user daemon-reload`. Al login preferire la sessione
   **Hyprland (uwsm-managed)**: è quella verificata nel test, con portali attivi. Non abilitare overview/hypridle
   su default.target: vengono avviati prima della sessione grafica.
   Hyprland avvia già overview; per hypridle avviare il servizio dalla sessione
   dopo aver verificato l'ambiente, oppure abilitarne un avvio legato alla sessione.
7. Accedere a Hyprland e collaudare launcher, audio, lock/suspend, screenshot,
   clipboard, overview, multi-monitor e dettatura. Riavviare e ripetere.
8. Ripristinare separatamente dati/account dal backup cifrato.

## Verifiche effettuate e limiti

Verifica sintassi Bash, simulazione e applicazione Stow in HOME temporanea,
seconda applicazione per controllare idempotenza e backup di conflitti.
Nessun pacchetto installato sul PC corrente e nessun suo servizio riavviato.
Successivamente è stata creata una VM Fedora pulita: vedere il
[rapporto del collaudo](vm-test/README.md) per metodo, schermate e limiti.
Il remoto GitHub HEAD corrispondeva a `236042e3186849880eef4d4d05ecdfff501c808f`.
