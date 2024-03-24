# Warp and Warp +

## در این پروژه 2 اسکریپت وجود وارد اولی نیاز به سرور دارد  و برای نصب warp روی سرور و تغییر آی پی آن استفاده میشود. و اسکریپت دوم روی `Termux` موبایل اجرا میشود که برای اسکن آی پی سالم و همچنین تولید کانفیگ رایگان WireGuard استفاده میشود.

 این اسکریپت به طور خودکار CloudFlare WARP را در لینوکس نصب و پیکربندی می‌کند، با کلاینت رسمی WARP یا WireGuard به شبکه‌های WARP متصل می‌شود.
 
 امکان فعال کردن warp یا warp + روی IPV4 و IPV6 به صورت انتخابی.

inatall
```
bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/install.sh)
```

![15](https://raw.githubusercontent.com/Ptechgithub/configs/main/media/15.jpg)


.

## اسکنر IP Warp و دریافت کانفیگ رایگان WireGuard برای V2ray و Nekobox و همچنين خود WireGuard 

```
bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh)
```
![16](https://raw.githubusercontent.com/Ptechgithub/configs/main/media/16.jpg)
#Endpoint IP scanner and free Config generator
### این اسکریپت برای اسکن IP وارپ استفاده می‌شود.
### ابتدا با انتخاب 1 یا 2 یک ای پی سالم پیدا کنید.
### با انتخاب 3 یک کانفیگ رایگان تولید میشود و به طور خودکار IP سالم  پیدا شده در کانفیگ اضافه میشود.
### این کانفیگ برای `V2rayNG` و `Nekobox` و برنامه `WireGuard` قابل استفاده است.


[دریافت License Key رایگان](https://t.me/generatewarpplusbot)

## Credits.
[P3TERX](https://github.com/P3TERX/warp.sh) & [yonggekkk](https://github.com/yonggekkk?tab=repositories)
