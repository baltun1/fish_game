# 🐟 Balık Evrim Savaş Oyunu

![Godot](https://img.shields.io/badge/Godot-4.x-478CBF?style=for-the-badge&logo=godot-engine)
![GDScript](https://img.shields.io/badge/GDScript-478CBF?style=for-the-badge&logo=godot-engine)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## 📖 Proje Hakkında

**Balık Evrim Savaş Oyunu**, küçük bir balık olarak başlayıp diğer balıkları yiyerek ve savaşarak evrimleştiğiniz heyecan verici bir 2D oyun. Her balık türünün kendine özgü özellikleri ve yetenekleri vardır. Oyuncu balığı zamanla daha güçlü, daha hızlı ve daha stratejik hale gelir.

### 🎮 Oyun Özellikleri

- **Evrim Sistemi**: Balık yedikçe özellikleriniz gelişir
- **Yetenek Sistemi**: Aktif ve pasif yetenekler kazanın
- **Çeşitli Balık Türleri**: Her balığın kendine özgü özellikleri
- **Dinamik Harita**: Farklı deniz bölgelerinde macera
- **Yapay Zeka**: Akıllı düşman balık davranışları

## 🚀 Kurulum

### Gereksinimler

- **Godot Engine 4.x** (en son sürüm)
- **Windows 10/11**, **macOS** veya **Linux**

### Kurulum Adımları

1. **Godot Engine'i İndirin**
   ```bash
   # Godot Engine'i resmi siteden indirin:
   # https://godotengine.org/download
   ```

2. **Projeyi Klonlayın**
   ```bash
   git clone https://github.com/your-username/balik-evrim-oyunu.git
   cd balik-evrim-oyunu
   ```

3. **Godot'ta Açın**
   - Godot Engine'i başlatın
   - "Import" butonuna tıklayın
   - Proje klasörünü seçin
   - "Import & Edit" butonuna tıklayın

4. **Oyunu Çalıştırın**
   - F5 tuşuna basın veya "Play" butonuna tıklayın

## 🎯 Oynanış

### Temel Kontroller

| Tuş | Aksiyon |
|-----|---------|
| **WASD** | Hareket |
| **Q** | Aktif Yetenek 1 |
| **E** | Aktif Yetenek 2 |
| **R** | Aktif Yetenek 3 |
| **ESC** | Menü/Pause |
| **Mouse** | Yön takibi (opsiyonel) |

### Oyun Mekaniği

1. **Küçük Balıkla Başlayın**: Oyuna küçük bir balık olarak başlarsınız
2. **Diğer Balıkları Yiyin**: Küçük balıkları yiyerek büyüyün
3. **Savaşın**: Eşit veya büyük balıklarla savaşın
4. **Evrimleşin**: Yeni özellikler ve yetenekler kazanın
5. **Keşfedin**: Farklı deniz bölgelerini keşfedin

### Yetenek Sistemi

#### Aktif Yetenekler (Manuel Kullanım)
- **Dash**: Hız patlaması
- **Cloak**: Görünmezlik
- **Toxic Trail**: Zehirli iz
- **Clone**: Klon üretimi
- **Shockwave**: Alan etkili saldırı

#### Pasif Yetenekler (Otomatik)
- **Yaradan Güç**: Saldırıda can kazanma
- **Zehirli Kan**: Saldıran düşmana hasar
- **Can Yenilemesi**: Otomatik can yenileme
- **Efsane DNA**: Tüm özelliklerde bonus
- **Savaş Hafızası**: Tekrar savaşlarda avantaj

## 🏗️ Proje Yapısı

```
balik-evrim-oyunu/
├── scenes/              # Godot sahneleri
│   ├── MainMenu.tscn    # Ana menü
│   ├── Game.tscn        # Oyun sahnesi
│   └── GameOver.tscn    # Game over
├── scripts/             # GDScript dosyaları
│   ├── Fish.gd          # Balık temel sınıfı
│   ├── Player.gd        # Oyuncu balığı
│   ├── Enemy.gd         # Düşman balıklar
│   └── GameManager.gd   # Oyun yöneticisi
├── assets/              # Grafik ve ses dosyaları
│   ├── sprites/         # Balık sprite'ları
│   ├── backgrounds/     # Arka planlar
│   └── sounds/          # Ses efektleri
├── TODO_001.md          # Detaylı görev listesi
├── DEV_LOG_01.md        # Geliştirici log
└── README.md            # Bu dosya
```

## 🧪 Geliştirme

### Geliştirme Ortamı Kurulumu

1. **Godot Engine'i İndirin**
2. **Projeyi Açın**
3. **GDScript Editörünü Kullanın**

### Kod Standartları

- **Dosya İsimleri**: PascalCase (örn: `PlayerFish.gd`)
- **Değişken İsimleri**: snake_case (örn: `player_health`)
- **Fonksiyon İsimleri**: snake_case (örn: `calculate_damage()`)
- **Sabitler**: UPPER_SNAKE_CASE (örn: `MAX_HEALTH`)

### Test Etme

```bash
# Oyunu test modunda çalıştırın
# Godot'ta Debug menüsünden test araçlarını kullanın
```

## 📝 Katkıda Bulunma

1. Bu repository'yi fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Değişikliklerinizi commit edin (`git commit -am 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/yeni-ozellik`)
5. Pull Request oluşturun

### Katkı Alanları

- 🐛 Bug düzeltmeleri
- ✨ Yeni özellikler
- 🎨 UI/UX iyileştirmeleri
- 📚 Dokümantasyon
- 🧪 Test yazımı

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 🤝 İletişim

- **Proje Sahibi**: [İsminiz]
- **E-posta**: [e-posta@adresiniz.com]
- **GitHub**: [github.com/kullanici-adi]

## 🙏 Teşekkürler

- **Godot Engine** ekibine harika oyun motoru için
- **Açık kaynak topluluğuna** katkıları için
- **Test edenlere** geri bildirimleri için

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın! 