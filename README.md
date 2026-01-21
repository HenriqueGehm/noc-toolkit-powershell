# NOC Toolkit PowerShell

Toolkit de suporte/NOC em PowerShell para automação de healthchecks, conectividade, HTTP check, alertas e logs em ambiente Windows.

## 🎯 Objetivo

Padronizar triagem inicial de alertas em NOC, gerar evidências rápidas e facilitar comunicação com times especialistas.

## 📋 Scripts inclusos

### 1. `Get-SystemHealth.ps1`
Healthcheck rápido do servidor: uptime, CPU, memória, disco, rede e serviços críticos.

**Uso:**
```powershell
.\Get-SystemHealth.ps1
