# Warp and Warp +

## در این پروژه 2 اسکریپت وجود وارد اولی نیاز به سرور دارد  و برای نصب warp روی سرور و تغییر آی پی آن استفاده میشود. و اسکریپت دوم هم روی سرور و هم روی `Termux` موبایل اجرا میشود که برای اسکن آی پی سالم و همچنین تولید کانفیگ رایگان WireGuard استفاده میشود.



# [1]

 این اسکریپت به طور خودکار CloudFlare WARP را در لینوکس نصب و پیکربندی می‌کند، با کلاینت رسمی WARP یا WireGuard به شبکه‌های WARP متصل می‌شود.
 
 امکان فعال کردن warp یا warp + روی IPV4 و IPV6 به صورت انتخابی.

inatall
```
bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/install.sh)
```

![15](https://raw.githubusercontent.com/Ptechgithub/configs/main/media/15.jpg)


.



# [2]
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
### هنگام کپی کردن کانفیگ و قرار دادن ان در برنامه های ذکر شده اگر با خطا مواجه شد. مشکل از نحوه ی کپی شدن و وجود فاصلخ های اضافی در بین کاراکتر ها میباشد، بهتر است ابتدا در یک فتیل ان را قرار بدید(پیست کنید) و فواصل اضافی را پاک کنید و مجدد با کپی کردن کامفیگ آن را در برنامه های ذکر شده وارد کنید.
### اگر از IPV6 استفاده کردید پس از وارد کردن کانفیگ در V2ray باید قبل و بعد از IP علامت [ ] قرار بدید یعنی آی پی را درون آن بگذاريد تا مشکل اتصال نداشته باشید. و اینکه IPV6 روی همراه اول کار نمیکنه و خطای timeout دریافت میکنید.
### اگر با `Termux` مشکل دارید برای حذف کامل آن دستور `rm -rf $PREFIX` را اجرا کنید تا تمام فایل ها حذف شوند و یک بار توقف اجباری بزنید. و سپس کلیر دیتا کنید. مجدد وارد برنامه بشید و دستورات ` pkg update -y` و `pkg upgrade -y` و `pkg install curl -y` را اجرا کنید در پاسخ به سوالات فقط `y` را بزنید و درنهایت خود اسکریپت را اجرا کنید.


[دریافت License Key رایگان](https://t.me/generatewarpplusbot)

## Credits.
[P3TERX](https://github.com/P3TERX/warp.sh) & [yonggekkk](https://github.com/yonggekkk?tab=repositories)
