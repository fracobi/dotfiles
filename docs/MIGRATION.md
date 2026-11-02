# Nuovo PC: installa la base, poi completa il tuo setup

Riferimento verificato: Fedora 44 tradizionale con KDE, su x86_64. Non Atomic/Kinoite.
Questa repo ripristina il desktop e le sue dipendenze, non partizioni, dati o account.

## 1. Installa la base

Dopo aver installato Fedora e verificato rete e driver:

```bash
sudo dnf install git
git clone --recurse-submodules https://github.com/fracobi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap-fedora.sh
```

Il bootstrap mantiene le conferme DNF. Abilita i COPR `sdegler/hyprland` e
`atim/starship`, aggiunge il repository ufficiale Brave e installa il manifest
`packages/fedora.txt`. Se manca il fork Noctalia, lo compila al commit verificato
nel test. La prima build richiede tempo e pacchetti di sviluppo. Installa inoltre
JetBrainsMono Nerd Font v3.4.0 verificando un checksum fissato nella repo.
Non installa una copia completa delle migliaia di pacchetti dell'inventario.
Dopo aggiornamenti Qt che richiedono una ricompilazione del runtime, eseguire
`./scripts/install-noctalia-qs-fedora.sh` e rientrare nella sessione.

Fonti delle procedure esterne: [Brave Fedora DNF5](https://brave.com/linux/),
[Starship](https://starship.rs/guide/),
[Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases/tag/v3.4.0).

Non eseguire come root. Conserva il clone: Stow collega i file da quella cartella.
I conflitti vengono salvati in `~/.local/state/dotfiles/backups/`.
Per aggiornare una macchina già configurata, verifica i backup e le differenze
prima di riapplicare i file: l'installer può ripristinare i valori del template.

## 2. Primo login e verifica

Seleziona **Hyprland (uwsm-managed)** al login. I portali devono essere gestiti
dalla sessione UWSM. Il bridge KDE non parte automaticamente in Hyprland, ma
rimane disponibile in Plasma e può essere avviato manualmente se serve alle
applicazioni X11. La condivisione schermo completa va comunque provata nel browser.

```bash
cd ~/dotfiles
./scripts/check-setup.sh
```

Il comando restituisce errore se manca qualcosa della base; elenca separatamente
i componenti opzionali. `./scripts/check-setup.sh --strict` richiede anche tutti
quelli opzionali. Non indica un setup incompleto solo perché non usi la dettatura.

- [ ] Super+Invio apre Kitty; Super+Spazio apre il launcher.
- [ ] Super+Tab e il pulsante overview funzionano anche senza plugin aggiuntivi.
- [ ] Screenshot, clipboard, audio e selezione file funzionano.
- [ ] Verifica nel browser condivisione schermo/microfono.
- [ ] Prova blocco schermo e sospensione sul PC fisico.
- [ ] Riavvia e ripeti i controlli essenziali.

Per usare Zsh come shell predefinita:

```bash
chsh -s "$(command -v zsh)"
```

Poi esci e rientra. Il profilo non fallisce se uno strumento opzionale manca.

## 3. Monitor e percorsi personali

Su un clone nuovo i monitor usano risoluzione preferita, scala 1 e disposizione
automatica. Lo script workspace usa un output esistente anche senza `eDP-1`.
Per personalizzare, copia `examples/local.lua` in `~/.config/hypr/local.lua` e
modifica gli output mostrati da `hyprctl monitors`.

Il profilo `DOTFILES_MONITOR_PROFILE = "current"` ripristina il vecchio assetto
1920×1080, eDP-1 a scala 1.2 + HDMI-A-1. È quello conservato nella configurazione
locale del PC sorgente. Non copiarlo alla cieca su un altro hardware.
`local.lua` è escluso da Git e Stow: l'installer non lo sovrascrive.

Scorciatoie, tastiera e prompt usano HOME/PATH. L'installer adatta al nuovo HOME
i percorsi assoluti rimasti nel template Noctalia e in hyprpaper, sostituendo il
singolo symlink del file personalizzato senza riscrivere il template della repo.
Su una HOME diversa, quei file diventano copie locali: modifiche future non
ritornano automaticamente nella repo. Nessuna foto o wallpaper viene copiata.

- [ ] Ripristina gli sfondi e scegli la cartella da Noctalia → wallpaper.
- [ ] Imposta la foto profilo da Noctalia se la desideri.
- [ ] Ripristina eventuali mount Windows; `/mnt/windows` non viene creato.
- [ ] Ricrea le PWA Brave. L'ID WhatsApp del vecchio profilo non è portabile:
      finché non esiste, il suo avvio viene saltato.

## 4. Componenti opzionali: cosa installare e dove

| Funzione | Cosa manca su una macchina nuova | Completamento |
| --- | --- | --- |
| Super+Y | `spf` | Installare [Superfile](https://github.com/yorukot/superfile) seguendo le istruzioni upstream; verificare `command -v spf` |
| Super+K | `wvkbd-mobintl` | Compilare/installare [wvkbd](https://github.com/jjsullivan5196/wvkbd) con layout mobintl e rendere il binario disponibile nel PATH |
| Ctrl+Shift+E in Kitty | `llm-chat` e relativo motore/modello | Ripristinare dal proprio backup gli script personali e la relativa configurazione; non sono distribuiti dalla repo |
| Pannello rete personalizzato | `nmtui-go` | Ripristinare lo strumento personale oppure usare le impostazioni rete standard di Noctalia/Fedora |
| Rclone/Documenti | programmi, credenziali, mount e timer | Ripristinare da backup cifrato e verificare sorgente/destinazione prima di abilitare sincronizzazioni |
| Telefono | pairing e dipendenze dei plugin | Installare gli strumenti richiesti dal plugin e rifare il pairing; non copiare chiavi nella repo pubblica |

I lanci opzionali di Superfile e tastiera mostrano un messaggio se il programma
manca. Dettatura assente: nessuna registrazione viene avviata, compare un messaggio
che rimanda a questa checklist.

### Dettatura locale, Super+D / Super+Esc

Gli script e l'indicatore sono inclusi; motore e modello sono separati. Ricetta
manuale basata sul commit del motore presente sul PC sorgente:

```bash
sudo dnf install git cmake gcc-c++ make
mkdir -p ~/.local/share
git clone https://github.com/ggml-org/whisper.cpp.git ~/.local/share/whisper.cpp
cd ~/.local/share/whisper.cpp
git checkout --detach 231638a0717b7822784297e5980965ffcec05810
cmake -B build -DCMAKE_BUILD_TYPE=Release -DGGML_CUDA=OFF
cmake --build build --parallel 2
bash models/download-ggml-model.sh base
mkdir -p ~/.local/share/applications/waystt/models ~/.config/waystt
cp models/ggml-base.bin ~/.local/share/applications/waystt/models/
cp ~/dotfiles/examples/waystt.env ~/.config/waystt/.env
```

La ricetta è documentata, non collaudata in questa VM con un microfono reale.
Il download del modello richiede rete e spazio. I parametri di esempio sono
pubblici; non aggiungere credenziali al file `.env`. Prova prima una frase breve,
poi verifica la trascrizione: lo script incolla il testo ma non preme Invio.

### Plugin overview aggiuntivo

L'overview Quickshell funziona senza plugin compilati. Se vuoi `scrolloverview`,
usa una versione compatibile con il tuo Hyprland, seguendo
[le istruzioni del plugin](https://github.com/yayuuu/hyprland-scroll-overview):

```bash
hyprpm add https://github.com/yayuuu/hyprland-scroll-overview.git
hyprpm update
hyprpm enable scrolloverview
hyprpm reload -n
```

Non eseguito nella VM: il plugin deve corrispondere all'ABI del compositor.
La repo upstream può evolvere o cambiare nomi: controlla `hyprpm list` e
`hyprctl plugin list`. L'autostart ricarica solo plugin registrati e abilitati;
con nessuno registrato non mostra più l'errore degli header mancanti.
Il pulsante overview usa il plugin se effettivamente caricato, altrimenti
l'overview Quickshell. Non è necessario installarlo per usare il desktop.

## 5. Dati, account e applicazioni

- [ ] Ripristina documenti, progetti e file da backup separato.
- [ ] Accedi a Brave/Atuin e agli altri account; non sono trasferiti dalla repo.
- [ ] Ripristina SSH/GPG e credenziali solo da backup cifrato.
- [ ] Installa le app personali confrontando `inventory/flatpak-apps.tsv` e
      `inventory/rpm-installed.txt`, senza reinstallare indiscriminatamente driver
      e dipendenze del vecchio hardware.
- [ ] Installa driver GPU, codec, stampanti e strumenti di sviluppo necessari.
- [ ] Valuta le attività systemd personali: non vengono abilitate automaticamente.

## Stato delle verifiche

Vedere [il rapporto VM](vm-test/README.md) per la prova iniziale. Il successivo
consolidamento verifica bootstrap e dipendenze aggiunte, portabilità dei percorsi,
configurazione Lua, profilo monitor locale e override autostart del bridge.
La virtualizzazione non certifica GPU fisiche, batteria, sospensione o periferiche.
