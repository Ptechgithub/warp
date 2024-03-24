# Warp and Warp +

## در این پروژه 2 اسکریپت وجود وارد اولی نیاز به سرور دارد  و برای نصب warp روی سرور و تغییر آی پی آن استفاده میشود. و اسکریپت دوم هم روی سرور و هم روی `Termux` موبایل اجرا میشود که برای اسکن آی پی سالم و همچنین تولید کانفیگ رایگان WireGuard استفاده میشود.

### برای اسکن ای پی روی ویندوز فایل [win_warp_ip.zip](https://github.com/Ptechgithub/warp/blob/main/endip/win_warp_ip.zip) دانلود کنید و از حالت فشرده خارج کنید سپس فایل win_scaner را اجرا کنید. 
---
---

# [1]

 این اسکریپت به طور خودکار CloudFlare WARP را در لینوکس نصب و پیکربندی می‌کند، با کلاینت رسمی WARP یا WireGuard به شبکه‌های WARP متصل می‌شود.
 
 امکان فعال کردن warp یا warp + روی IPV4 و IPV6 به صورت انتخابی.

inatall
```
bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/install.sh)
```

![15](https://raw.githubusercontent.com/Ptechgithub/configs/main/media/15.jpg)


---
---

# [2]

install
```
bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh)
```
![16](https://raw.githubusercontent.com/Ptechgithub/configs/main/media/16.jpg)


## اسکنر IP Warp و دریافت کانفیگ رایگان WireGuard برای V2ray و Nekobox و همچنين خود WireGuard 

#Endpoint IP scanner and free Config generator
### این اسکریپت برای اسکن IP وارپ استفاده می‌شود.
### ابتدا با انتخاب 1 یا 2 یک ای پی سالم پیدا کنید.
### با انتخاب 3 یک کانفیگ رایگان تولید میشود و به طور خودکار IP سالم  پیدا شده در کانفیگ اضافه میشود.
### این کانفیگ برای `V2rayNG` و `Nekobox` و برنامه `WireGuard` قابل استفاده است.
### هنگام کپی کردن کانفیگ و قرار دادن ان در برنامه های ذکر شده اگر با خطا مواجه شد. مشکل از نحوه ی کپی شدن و وجود فاصله های اضافی در بین کاراکتر ها میباشد، بهتر است ابتدا در یک فایل ان را قرار بدید(پیست کنید) و فاصله های اضافی را پاک کنید و مجدد با کپی کردن کانفیگ آن را در برنامه های ذکر شده وارد کنید.
### اگر از IPV6 استفاده کردید پس از وارد کردن کانفیگ در V2ray باید قبل و بعد از IP علامت [ ] قرار بدید یعنی آی پی را درون آن بگذاريد تا مشکل اتصال نداشته باشید. و اینکه IPV6 روی همراه اول کار نمیکنه و خطای timeout دریافت میکنید.
### هر ای پی که می‌گیرد صد درصد سالم نیست پس اگر جواب نداد یک آی پی دیگر مجدد بگیرید و آی پی را در قسمت آدرس کانفیگ قرار بدید یا اینکه مجدد 3 رو بزنید و کانفیگ رایگان دیگری بگيريد. 
### اگر با `Termux` مشکل دارید برای حذف کامل اطلاعات موجود در برنامه
### دستور `rm -rf $PREFIX` را اجرا کنید تا تمام فایل ها حذف شوند و یک بار توقف اجباری بزنید. و سپس کلیر دیتا کنید. مجدد وارد برنامه بشید و دستور زیر را وارد کنید:
`pkg update -y && pkg upgrade -y && pkg install curl -y`
 ### در پاسخ به سوالات فقط `y` را بزنید و درنهایت خود اسکریپت را اجرا کنید.
 ### برای گرفتن کانفیگ رایگان به تعداد زیاد درخواست نفرستید چون با خطای `Too Many Requestt` مواجه می شوید.  و باید صبر کنید.
### اگر لایسنس گرفتید و برای تبدیل به warp-plus پس دریافت کانفیگ دستور زیر را وارد کنید:
### `WGCF_LICENSE_KEY="Your License" wgcf update`
### لایسنس خودتون رو به جای `Your License` قرار بدید و اجرا کنید.

### برای دریافت لایسنس رایگان از طریق ربات تلگرام روی لینک زیر کلیک کنید.
[دریافت License Key رایگان](https://t.me/generatewarpplusbot)

## Credits.
[P3TERX](https://github.com/P3TERX/warp.sh) & [yonggekkk](https://github.com/yonggekkk) & [Misaka-blog](https://github.com/Misaka-blog) & [ViRb3](https://github.com/ViRb3/wgcf)
