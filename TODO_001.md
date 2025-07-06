# 🐟 Balık Evrim Savaş Oyunu – TODO.md

## 🎮 OYUNUN TEMEL FİKRİ
Oyuncu küçük bir balık olarak başlar. Diğer balıkları yiyerek ve savaşarak büyür. Her balığın kendine özgü özellikleri vardır. Balıklar yendikçe oyuncuya aktif veya pasif yetenek kazandırabilir. Oyuncu balığı zamanla daha güçlü, daha hızlı ve daha stratejik hale gelir. Bazı balıklar çok nadirdir ve özel özellikler taşır.

---

## ✅ GENEL GÖREVLER

### 🔧 1. PROJE ALTYAPISI
- [ ] Oyun motoru: Godot Engine (2D)
- [ ] Kod dili: GDScript
- [ ] Proje klasör yapısının oluşturulması
- [ ] Temel sahneler:
  - [ ] Ana Menü
  - [ ] Oyun Sahnesi
  - [ ] Game Over
  - [ ] Ayarlar / Ses

---

## 🐟 2. BALIK SİSTEMİ

### 2.1. Balık Temel Özellikleri
- [ ] ID, isim, boyut, hız, saldırı, defans, nadirlik
- [ ] Aktif yetenekler listesi
- [ ] Pasif yetenekler listesi
- [ ] Evrim puanı

### 2.2. Oyuncu Balığı
- [ ] Deneyim puanı (XP)
- [ ] Seviye sistemi
- [ ] Özellik geliştirme (yemeyle veya zaferle)
- [ ] Yetenek kazanımı (yendiği balıklardan)
- [ ] Görsel büyüme/evrim efektleri

### 2.3. Balık Evrimi
- [ ] Belirli balık türleri yendikçe:
  - [ ] Özellik devralma
  - [ ] Yeni yetenek kazanımı (aktif veya pasif)
  - [ ] Görsel değişim (renk, büyüklük, yüzgeç)

---

## ⚔️ 3. SAVAŞ MEKANİĞİ
- [ ] Balık çarpışmalarında:
  - [ ] Saldırı/defans değerleri karşılaştır
  - [ ] Kazanan balık diğerini yer
  - [ ] Oyuncu XP veya özellik kazanır
- [ ] Savaş animasyonları ve efektler
- [ ] Can sistemi (health bar)

---

## 🌊 4. OYUN DÜNYASI / HARİTA
- [ ] Sonsuz scrollable harita (yukarı/aşağı/sağa/sola)
- [ ] Farklı deniz bölgeleri:
  - [ ] Yüzey, orta, derin, karanlık
- [ ] Her bölgeye özel balık türleri
- [ ] Renk ve ışık farklılıkları

---

## 🧬 5. YETENEK SİSTEMİ

### 5.1. Aktif Yetenekler (Kullanıcı tetikler)
- [ ] Oyuncu maksimum 3 aktif yetenek taşıyabilir
- [ ] Her yetenek belirli bir tuşla çalışır (Q, E, R)
- [ ] Cooldown (bekleme süresi) uygulanır
- [ ] Enerji puanı sistemine bağlanabilir (opsiyonel)

#### Örnek Aktif Yetenekler:
- [ ] **Dash (Hız Patlaması)**: Geçici hız artışı
- [ ] **Cloak (Kamuflaj)**: Geçici görünmezlik
- [ ] **Toxic Trail**: Zehirli iz bırakır
- [ ] **Clone**: Kısa süreli klonlar üretir
- [ ] **Shockwave**: Alan etkili saldırı yapar

---

## 💡 6. PASİF YETENEKLER SİSTEMİ

### 6.1. Pasif Özellikler (Otomatik çalışır)
- [ ] Oyuncunun manuel tetiklemesine gerek yok
- [ ] En fazla 2 pasif yetenek taşıyabilir
- [ ] Balık yendikçe veya seviye atladıkça rastgele pasif gelir
- [ ] Aynı pasif tekrar edilirse etkisi artar (stack)

#### Örnek Pasifler:
| Pasif Yetenek | Açıklama |
|---------------|----------|
| **Yaradan Güç** | Saldırdıkça sağlık kazanılır |
| **Zehirli Kan** | Saldıran düşman hasar alır |
| **Can Yenilemesi** | Savaş dışı zamanlarda can yenilenir |
| **Efsane DNA** | Tüm temel özelliklerde %3 bonus |
| **Savaş Hafızası** | Daha önce yendiğin balıklar zayıflar |
| **Karanlık Adaptasyon** | Karanlık bölgede hız ve görüş artar |
| **Sersemletici Saldırı** | %5 ihtimalle düşmanı yavaşlatır |
| **Zayıfı Avla** | Küçük balıkları yerken ekstra XP |

---

## 🧠 7. YAPAY ZEKA (AI)

### 7.1 Düşman Balık Davranışları
- [ ] Küçük balık: Oyuncudan kaçar
- [ ] Eşit güce sahip balık: Oyuncuya yaklaşmaz
- [ ] Büyük balık: Oyuncuya saldırır
- [ ] Nadir balıklar: Derin sularda sessizce dolaşır

---

## 🖱️ 8. KONTROLLER

### 8.1 Klavye ve Mouse
- [ ] Yön tuşları (WASD) ile hareket
- [ ] `Q`, `E`, `R` → Aktif yetenekler
- [ ] `ESC` → Menü/Pause
- [ ] Mouse ile yön takibi (opsiyonel mod)

### 8.2 Dokunmatik Cihazlar
- [ ] Parmağın yönüne doğru yüzme
- [ ] Çift dokunuşla yetenek kullanımı

---

## 🎨 9. GÖRSEL VE SES

- [ ] 2D Sprite balık tasarımları
- [ ] Yüzme, saldırı, evrim animasyonları
- [ ] Farklı deniz ortamları için arka plan
- [ ] Ses efektleri:
  - [ ] Saldırı / yeme sesi
  - [ ] Seviye atlama sesi
  - [ ] Özel yetenek efektleri
- [ ] UI öğeleri:
  - [ ] Sağlık barı
  - [ ] Yetenek ikonları + cooldown
  - [ ] Pasif yetenek simgeleri

---

## 🧪 10. TESTLER
- [ ] Savaş sonucu hesaplamaları
- [ ] Balıkların doğru özellik taşıyıp taşımadığı
- [ ] Aktif yeteneklerin düzgün çalışması
- [ ] Pasif yeteneklerin tetiklenme durumu
- [ ] Harita geçişleri ve AI davranışı
- [ ] Oyuncu kaydedilme / yükleme kontrolü

---

## 💾 11. KAYIT / YÜKLEME
- [ ] Oyuncunun XP, seviye, özellikleri
- [ ] Aktif ve pasif yetenekler
- [ ] Konum ve gelişim kaydı

---

## 🌐 12. (OPSİYONEL) MULTIPLAYER PLANLAMASI
- [ ] Gerçek oyuncularla savaş (PvP)
- [ ] Online sıralamalar
- [ ] Oyuncular arasında yetenek takası sistemi

---

## 🔚 13. YAYINA HAZIRLIK
- [ ] Oyun dışı menüler (ana ekran, ayarlar)
- [ ] Tutorial sistemi (ilk girişte öğretici)
- [ ] Oyunun export edilmesi (Web, Android, iOS)
- [ ] Logo, isim ve tanıtım görselleri
- [ ] Yayın: itch.io, Google Play, App Store (opsiyonel)

---

## 📌 NOTLAR
- Geliştirme sürecinde öncelik: temel oynanış → balık sistemi → evrim → yetenekler → AI → görsellik → test
- Başlangıç için küçük bir harita ve 5-6 balık türü ile başlanmalı.
- Balık sistemine özellik geçişi ve evrim eklenerek büyütülmeli.

---

