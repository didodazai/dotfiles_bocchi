# Microfone no frieren — EasyEffects

## Estado declarativo

O EasyEffects e instalado pelo Home Manager apenas no perfil `home/profiles/frieren.nix` e iniciado como servico de usuario na sessao grafica. O sistema usa PipeWire/WirePlumber em `modules/services.nix`.

O preset `Bluefin-Microfone` e gerado via `services.easyeffects.extraPresets` e carregado no inicio via `services.easyeffects.preset`. Ele reconstrói a cadeia encontrada no backup do Bluefin em 12/10/2026.

| Ordem | Efeito | Ajustes recuperados |
| --- | --- | --- |
| 1 | RNNoise | Sem ajustes personalizados gravados; modelo padrao |
| 2 | DeepFilterNet | Attenuation Limit = 91; Post Filter Beta = 0.019999999552965164 |

O banco antigo registrava `plugins=rnnoise#0,deepfilternet#0` e nao continha preset nomeado, nem parametros customizados de RNNoise. Os demais parametros usam os defaults do EasyEffects atual (8.2.4 na instalacao inicial).

**Limite da recuperacao:** os arquivos de referencia nao confirmam o estado de bypass dos filtros. Nos testes do NixOS 8.2.4, o DeepFilterNet produziu chiado/estouros no Discord e o usuario relatou melhora ao desliga-lo. Por isso, o preset mantem **RNNoise ativo e DeepFilterNet em bypass** com os parametros originais guardados para futura comparacao. A versao do Bluefin era 8.3.0; a causa exata do artefato ainda nao foi determinada.

## Dispositivo de entrada

No Bluefin, a fonte era um microfone USB PnP da JMTek, identificacao USB `0c76:161e`, mono/48 kHz, com nome PipeWire `alsa_input.usb-0c76_USB_PnP_Audio_Device-00.mono-fallback`.

No NixOS, a lista de fontes tem mais de um `USB PnP Audio Device Mono`, alem do microfone Corsair. **Nao forcamos um ID ou source default no Nix**, porque eles podem variar e porque o sistema usa outros dispositivos de audio. Selecionar a entrada correta no EasyEffects e testar seu medidor de nivel.

No Discord, em **Configuracoes > Voz e video**, escolher a entrada virtual **Easy Effects Source**. Para comparar os efeitos, desativar temporariamente Krisp ou outra supressao do Discord. Nao selecionar diretamente o microfone USB para o teste processado.

## Verificacao no frieren (Fish)

```fish
cd ~/nixos-config
git pull --ff-only
osaragi-test
systemctl --user status easyeffects.service --no-pager
easyeffects --presets
wpctl status
```

Abrir `easyeffects`, confirmar que `Bluefin-Microfone` esta carregado na aba Input com **RNNoise ativado e DeepFilterNet desligado (bypass)**, e que o microfone USB correto alimenta essa cadeia. Fazer um teste de voz no Discord, com o medidor da entrada virtual reagindo a fala.

Apos validação, usar `osaragi` para fixar a geracao. Se houver erro ou voz distorcida, nao alterar a fonte global do PipeWire: revisar os dois filtros e relatar a saida de `journalctl --user -u easyeffects.service -n 60 --no-pager`.

**Nunca copiar os arquivos de banco `easyeffects/db/` do Bluefin diretamente por cima dos arquivos do NixOS.** O preset versionado substitui somente os ajustes relevantes.
