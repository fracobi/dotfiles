# Collaudo reale VM Fedora 44 — 2 novembre 2026

## Consolidamento successivo

Il bootstrap ora installa Starship, Atuin, Matugen, hyprshot, ImageMagick e Brave,
installa il font Nerd con checksum e avvia automaticamente la build Noctalia se
manca il runtime. Nella VM aggiornata il controllo della base restituisce **zero
problemi**; gli strumenti personali opzionali sono elencati separatamente.
La build del runtime era già presente da questa prova: non è stata ripetuta una
seconda compilazione pulita durante il consolidamento.

Sono stati verificati anche Zsh con PTY, configurazione Lua senza errori,
workspace su Virtual-1, fallback overview senza plugin e override XDG autostart:
provando ad avviare il bridge KDE in Hyprland, il servizio viene saltato e non
compare alcuna finestra nera. Il profilo monitor locale resta escluso da Stow.
Una prova separata in una HOME nuova verifica percorsi personalizzati senza
modificare i template e senza copiare backup o stato runtime.

Esiti registrati in [consolidation-result.txt](consolidation-result.txt).
Queste prove aggiornano i limiti del rapporto iniziale sotto. La procedura da
seguire è ora [docs/MIGRATION.md](../MIGRATION.md).

## Risultato iniziale

Il desktop Hyprland + Noctalia si avvia nella VM, ma il commit iniziale
`01d7069` **non installa da solo il setup completo**: il bootstrap termina con
exit 1 dopo aver installato i pacchetti, perché manca `noctalia-qs`.

È stato poi compilato nella VM il runtime dal repository pubblico
`https://github.com/noctalia-dev/noctalia-qs.git`, commit
`f308426239665e3bc3d624014e9295b2ae2f58ff`, senza copiare il binario del PC
sorgente. La build Release con Qt 6.11.2 è riuscita e restituisce
`noctalia-qs 0.0.12`. La ricetta è ora in
[`scripts/install-noctalia-qs-fedora.sh`](../../scripts/install-noctalia-qs-fedora.sh).
È stato inoltre aggiunto `dbus-tools` al manifest: senza, mancano
`dbus-monitor` e `dbus-update-activation-environment` usati dagli script desktop.

## Ambiente e metodo

- Immagine ufficiale Fedora Cloud Base Generic 44-1.7 x86_64; firma verificata
  con la chiave Fedora 44 installata sull'host e SHA256 verificato.
- KVM/QEMU, 4 vCPU, 4 GiB RAM, disco virtuale separato da 32 GiB, Virtio GPU.
- Clone ricorsivo da GitHub, account nuovo `cobi`, nessun file personale,
  credenziale o disco fisico condiviso con il guest.
- Prima esecuzione del bootstrap originale senza correzioni preventive.
- Applicazione manuale di `install.sh` per provare il compositor mentre il
  runtime compilava: questo passaggio ha deliberatamente superato il blocco
  del bootstrap ed è un intervento aggiuntivo, non un successo del bootstrap.
- Installazione dell'ambiente ufficiale `kde-desktop-environment` nel guest.
  La base rimane Cloud con KDE aggiunto: non è un test dell'installer ISO KDE,
  del partizionamento o delle impostazioni iniziali proprie della live ISO.
- Rendering software llvmpipe nella VM, senza passthrough GPU.
- Login automatico sulla console configurato soltanto nel guest per la prova;
  non fa parte dei dotfiles né della procedura per una macchina reale.

I repository attuali forniscono Hyprland **0.57.0**, mentre il PC sorgente usa
**0.56.2**. La configurazione Lua originale viene accettata anche da 0.57.0.
Dopo il riavvio UWSM, sono stati verificati Noctalia, overview e i due portali
attivi automaticamente, senza unità utente fallite. Il bootstrap aggiornato,
dopo la build aggiuntiva del runtime, termina con exit 0.

Il monitor virtuale è `Virtual-1`, 1280×800: non sono presenti i monitor fisici
`eDP-1` e `HDMI-A-1` del PC sorgente.

## Prove osservate

| Prova | Risultato |
| --- | --- |
| Pacchetti del manifest originale | Installati: nessun nome mancante |
| Bootstrap originale completo | Fallisce al controllo runtime, prima di Stow |
| Build runtime dal commit del PC sorgente | Riuscita |
| Applicazione Stow nella HOME del guest | Riuscita |
| Hyprland e configurazione Lua | Avvio riuscito; `hyprctl configerrors` vuoto |
| Kitty | Finestra visibile e Fastfetch funzionante |
| Clipboard Wayland | Scrittura e lettura dello stesso testo riuscite |
| Screenshot con grim | File generato correttamente |
| Noctalia | Processo attivo e barra visibile |
| Launcher Noctalia | Aperto tramite IPC e verificato nella schermata |
| Control Center | Aperto tramite IPC e verificato nella schermata |
| Overview Quickshell | Servizio attivo e miniature/workspace visibili |
| Riavvio tramite UWSM | Desktop e portali ripartiti automaticamente |
| Bootstrap dopo la build del runtime | Exit 0 |
| Super+Invio dopo il riavvio | Kitty aperto dalla scorciatoia |
| Zsh completo | Mancano Starship e Atuin nel manifest originale |

I comandi IPC lanciati via SSH richiedono lo stesso `WAYLAND_DISPLAY` del
desktop: senza, il client segnala «No running instances», anche se il processo
è attivo. Questo è stato corretto nel test, non nella configurazione desktop.

## Schermate reali

Le immagini sono catture del framebuffer QEMU, senza ricostruzioni grafiche.

- [Primo avvio Fedora pulito](01-fedora-clean-boot.png)
- [Hyprland senza runtime Noctalia](02-hyprland-before-runtime.png)
- [Primo avvio Noctalia e messaggio privacy](03-noctalia-first-start.png)
- [Desktop](04-noctalia-desktop.png)
- [Launcher](05-launcher.png)
- [Control Center](06-control-center.png)
- [Overview](07-overview.png)
- [Dopo il riavvio UWSM, con finestra nera del bridge KDE](08-after-reboot.png)
- [Preview finale dopo aver fermato il bridge nel guest](10-desktop-preview.png)

Il messaggio privacy è stato confermato mantenendo la telemetria disattivata.
Il guest non ha i tuoi sfondi o la tua foto; l'aspetto risultante comprende
quindi fallback grafici. Le icone del tema possono apparire prima dei relativi
font personali: anche i font esterni vanno installati esplicitamente.

## Cosa resta incompleto

1. Starship, Atuin, Brave e altri strumenti locali non sono installati dal
   manifest iniziale. Servono ricette dedicate e versioni definite.
2. `hyprpm reload` segnala header/plugin non preparati. L'overview Quickshell
   funziona; il plugin distinto `scrolloverview`, richiamato da un pulsante,
   non è stato installato o verificato.
3. Foto, sfondi, modelli Whisper, pairing telefono, dati e account restano
   esterni. La dettatura non è funzionante senza modello, motore e parametri.
4. Percorsi `/home/cobi` e nomi monitor restano specifici del PC. Lo script di
   sincronizzazione workspace continua a presumere `eDP-1` quando HDMI manca.
5. Nel primo avvio diretto i portali risultano inattivi: `graphical-session.target`
   ha `RefuseManualStart=yes`. Con l'ingresso UWSM fornito da Fedora,
   `graphical-session.target`, `xdg-desktop-portal` e
   `xdg-desktop-portal-hyprland` risultano attivi dopo il riavvio.
   Su un PC reale selezionare **Hyprland (uwsm-managed)** al login.
   Non è stato effettuato uno screen sharing completo da un browser.
6. Con KDE installato, `xwaylandvideobridge` parte in autostart e apre una
   finestra nera che il layout tratta come una normale finestra. È stato
   fermato solo nel guest per la preview finale. La repo non contiene ancora
   una regola/override per questo caso: aggiungere regole Hyprland appropriate
   oppure un override XDG autostart specifico per Hyprland. Dopo il riavvio è
   comparso anche un segfault dell'helper `hyprland-update` in libhyprtoolkit;
   il compositor e Noctalia hanno continuato a funzionare.
7. La VM senza dispositivo audio emulato mostra Dummy Output: l'audio reale,
   microfono, Bluetooth, luminosità, batteria e sensori non sono verificati.
8. Driver GPU reali, Secure Boot, sospensione, multi-monitor fisico,
   sincronizzazione cloud e ripristino dei dati non sono coperti da questa prova.

## Difetto del framebuffer del viewer e correzione solo VM

Il viewer ha richiesto un modo video 778×788. La cattura QEMU e il display VNC
risultavano distorti, mentre la cattura `grim` interna era corretta.
Il confronto della barra superiore dava differenza media 19,36 (soglia 10).
Ripristinando **solo** la risoluzione 1280×800@60, la differenza è scesa a 1,72:
nessuna modifica al renderer Qt o a Noctalia. Vedere la
[cattura del difetto](09-qemu-framebuffer-issue.png).

È stato aggiunto un monitor `Virtual-1` a modo fisso nella copia dei dotfiles
**del guest**, senza modificare i monitor del PC sorgente o della repo pubblica.
Il confronto e il reload della configurazione sono riusciti dopo la correzione.
È un limite della catena video virtuale, distinto dal ripristino dei dotfiles.

L'account del test si chiama `cobi`, quindi non verifica la portabilità verso un
nome utente diverso: i percorsi assoluti restano un problema noto.

Al termine del consolidamento la VM è stata spenta ordinatamente. Porte SSH
2227 e VNC 5907 chiuse, controllo QMP non più attivo; disco conservato.

## File locali della VM

Disco, immagine base, chiave SSH temporanea e log dettagliati sono in `.vm-test/`,
esclusa da Git. Non spostare il disco overlay separandolo dall'immagine base.
Le porte sono limitate a localhost: SSH 2227, VNC 5907. La VM non è stata
registrata tra quelle libvirt esistenti e non modifica `linux2024`.

Avvio dopo lo spegnimento, dalla cartella della repo:

```bash
./.vm-test/start-vm.sh
remote-viewer vnc://127.0.0.1:5907
```

Chiudere il viewer non spegne la VM. Per spegnerla:

```bash
./.vm-test/ssh-vm 'sudo poweroff'
```
