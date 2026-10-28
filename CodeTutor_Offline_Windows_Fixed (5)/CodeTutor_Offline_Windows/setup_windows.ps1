$ErrorActionPreference = "Stop"
Write-Host "Code Tutor Offline - Windows setup" -ForegroundColor Cyan
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Host "Flutter was not found. Install Flutter SDK and add flutter\bin to PATH first." -ForegroundColor Yellow
  exit 1
}
flutter doctor
flutter config --enable-windows-desktop
flutter create --platforms=windows .
flutter pub get
Write-Host "Setup completed. Run: flutter run -d windows" -ForegroundColor Green
