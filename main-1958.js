const createClient=window.supabase?.createClient;
if(!createClient){
  const app=document.getElementById('app');
  if(app)app.innerHTML='<main class="login"><h1>BMS Mobile</h1><p class="error">Library aplikasi gagal dimuat. Silakan muat ulang halaman.</p></main>';
  throw new Error('Supabase client library failed to load');
}

const db=createClient('https://mqqrfhwqgcpkjeaasdsr.supabase.co','sb_publishable_iJ0t2vhUt-iSwIN8Tky8IQ_XBnonQn4');
const root=document.getElementById('app');
const BMS_PRINT_LOGO='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAcFBQYFBAcGBgYIBwcICxILCwoKCxYPEA0SGhYbGhkWGRgcICgiHB4mHhgZIzAkJiorLS4tGyIyNTEsNSgsLSz/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCADPAUADASIAAhEBAxEB/8QAHAABAAMBAQEBAQAAAAAAAAAAAAEGBwUIBAMC/8QASRAAAQMDAQQGBQgHBgUFAAAAAQACAwQFEQYSITFBBxNRYXGBFCKRocEVIzI2QlJisRZDcnOTstEXM1R0gsIkVdLh8UVTkqLw/8QAGwEBAAIDAQEAAAAAAAAAAAAAAAUGAwQHAgH/xAA5EQABAwICBgkCBQQDAQAAAAABAAIDBBEFIRIxQVFxoQYTImGRscHR8DKBMzRCcuEUFSNSFlPxYv/aAAwDAQACEQMRAD8A9IoiIiIiIiIiIiIiIiIiIiIiIiIiIiIoUoiIoU4RERNwVH1T0jUlr26S17FXVjcZOMcZ/wBx8Fmhgkndoxi61qmqipWacpsFeEVF0x0kUtx2KW77FJUncJRujef9p9yvIIIBByDwKTQSQO0ZBZfKariqmacTrhSiIsK2kREREREREREREREREREREREREREREQ8EUHgiKURERERMIiIiIiIiIiIiIiIiIiIiYRERMKOCIpXwXa9UFjozU19Q2Jn2Rxc49gHNVjVHSLR2nbpbbsVlYNxdnMcZ7zzPcFlVxudZdqx1VXVD55Xc3HcB2Acgpekwx83akybzKruI45FTXjh7TuQVj1Rr+vvpfTUu1R0J3bDT68g/EfgPeqkpa0ucGtBc4nAAGSSrrp3o0uFy2Ki5l1DTHfsY+dcPD7Pn7FYSYKKO2ocz7qnBtXict83HkPQKkq0aZ13cdPlsEpNXQjd1Tz6zB+E8vDguhqLozr7dt1Frca6nG/q/1rR4fa8t/cqQ5rmPLXNLXNOCCMEFfQ6CtjtrHkjmVWGS3zaeR9CvQVlv9uv9J19BOH4+mw7ns8QullecqGvqrbVsqqOd8EzODmHH/kLUNMdJVNXbFLeNilqDuEw3RvPf90+5V+rwt8XaizHNW/DsdiqLRz9l3I+yvqKAQ4BzSCDvBHNSoZWREREREyoUoiIiYREyiIiIiIiIiJhERDwRDwRERERETKIiIiJhEUKURETKJhERERERQpRUzVHSJQ2fbpaDZrK0bjg/NxnvPM9wWaGF8ztGMXK16ipipmacpsFZbreKGy0Zqa+obDGOGeLj2Acysm1T0g118L6aj2qOhO4tB9eQfiPIdwVbud1rbxWOqq6odPKe3g0dgHIL6LJp656gqOqoKcvaDh0rtzGeJ+HFWWmw+KlHWTG55BUitxiorndTTggHdrK5mcKx6e0PdtQFsrY/RaQ/r5RjI/COJ/JX6x9HtpsUJrbiRXTxNLyXN+bZjfubz81V7n0wTRXdwoIY30kIlY3H0Zs46t+/BGBnIWnW44yLsxePsFM4L0OqK4l0g1bB6n28VftPaNtWnmh8EXXVON9RLvd5dnku+uDpTVlFqy3vqKQOjfG7EkTuLN5xk8MkDOBnC7ygnTGY6bje6sv9IKMmDR0bbEXB1Bo61aiYXVEPU1ON1RFud59vmu8i+skdG7SYbFY5YWTN0JBcLDdQ6Gu1gLpTH6XSD9dEOA/EOI/JVvK9KkZGDwVP1F0c2y77c9FigqzvywfNuPe3l4hWClxf9M4+6qNd0dIu+lP2PoffxVB0zrm46eLYXk1dDzhed7f2Ty8OC1yx6ht2oKXrqGcOI+nG7c9niPisQvenLnp+fq66mc1hOGyt3sd4H4Hevho62pt1WyppJ3wTM4PYcFbVRQQ1Y6yI2O8aitCjxaow93Uzglo2HWOC9HqVQNL9JlPWllJedmmnO4TjdG/x+6fd4K/AhzQ5pBBGQRzVZnp5IHaMgsrxS1cNWzTiN/TiilQpWBbSIiIiIiIiIiIiJvRERQvnrrhS2ykfVVk7IIWcXPPu7yuRfdWQWyf0Gihfcbo/wCjTQ7y3vceQXDh0Xc9Q1ba/VdYSBvZRwHDWDszy8t/etuOAW05jojmeA9dS0Jqt1zHTt0nchxPoM1y7prC86sqnWzTVNNHAdz5huc4d54MHvXT090YUdEW1N4kFZPx6of3YPfzd+SutFQ0ttpW09HTx08TeDWDA/7r6FlfWlrergGi3meJWtHhge/rqs6buQ4Bcqov9jtcvoc1wpKZ8QA6ouDdkct3Jfl+l+nv+cUn8QLIdb/Xa6fvf9oXAUpFhEckbXlxzF1Bz9IZopXRtYLAkbdi339MNPf85pP4gQaw08f/AFmk/iBYEiyf2WP/AGKw/wDJZ/8AQc16Gg1BZ6k4hulG8nkJm5/NdAEOGWkEHgQvNK6tn1JdbFM19FVvawHfE47THeIWGTBDa8b/ABWzD0mBNpmZdx9P5XoFfxNK2CCSZ5wyNpc49wGVxdKaqptT28ysHVVMWBNDn6J7R2gr6dTz+j6VucpOMUzwPEjHxUEYnNk6twsb2VpFQx8PXRm4tdfrZbxTX21RV9IXdVJkYdxaQcEFZZ0vaWlguA1DTMLoJgGVGB9Bw3Bx7iMDxHevt6Kr2Ke4T2eR2GVA62LP3wN48x+S1OWKOeF8U0bZI3jZcxwyCOwhfcRoxG90R1bFsdHcZcwMq25nU4efuF5RRbRqLoft9Ztz2Wc0Mx3iF/rRE9g5t96yW72ausVxfQ3GAwzs344hw5EHmFW5YHxfUuvUOKU1cP8AEc9x1/OC+BSEULCpRSAS9oAycjC9TTVcVBanVdU7Yjhi23nswFg3R5pWo1FqKCd0Z+T6R4kmkI3OI3hg7ST7loHSpfRFRQ2aJ+Hz4lmxyaDuHmd/kpzCaZ0z9Hf5bVzLpviMcDW2NywHxNrDkrxa7jDd7VBX04cIp27TQ4bx4r61VujebrdD0rScmN72f/Yn4ro6m1JS6atZqZ/Xlf6sUQO97v6dpUhJCRMYmC+dgqdDUtNM2okNhYE+C6s08VNC6WeVkUbd5c9wAHmVWa3pG05RuLW1b6lw5QMLh7TgLJr3qG46gqjNXTlzc+pE3cxngPiuWp2DBm2vM7PuVWqekjybU7ct59lrR6WbQHYFDWkduG/1X2UnSfp6ocGyuqKYnnJHke1uVjKLaOEU5GV/FaLekNYDc2P2Xo6huNHcoBPRVUVRH96NwOPHsX0OAc0tcAQRgg8150t10rbRWNqqGofBK3m07j3Ecwtq0fquLU9tLnBsVZDgTRjh3OHcVC1uHPphptN2+SsuG4zHWnq3jRdyPBczUPRrbbrtz28igqTvw0fNuPeOXl7FWaG9aj0BUNpLpTPqLeThoJy0D8D+XgfctbX5z08NVA6GoiZNE8Ycx4yD5LFHXODermGk3v1/YrPNhbC/rqY6D+7UeIXw2a+2+/0gqKCcSD7TDuew9hHJdJUW49Hz6Os+UdMVjqCqbv6pzjsO7geQ7jkL7rRrGRlU22ajpjbK/g17t0U3geA/JeJKdrhpwG43bR78QskVW9hEdW3RO/8ASfvsPcVbFClFpKTRQeClOSIiIiIi+G5UdXWsZDBWGjidnrXxt+cI7Gk7m+OCvuTK+g6JuF5c0OFivhtlmoLPCY6KnbFtb3v4vee1zjvJX2qVCOcXG5KNa1g0WiwRSoUr4vSwfW/12un73/aFwF39b/Xa5/vR/KFwDwV+pvwWcB5Lk1Z+Yk/cfNX+h6KqmtoKeq+VYmddG2TZ6knGRnGcr9X9EVXs+pdoXHsdER8Volk+r9v/AMtH/KF9yqzsUqQ4gO5BXuPA6JzASzZvPusEv+krrpwh1ZCHQOOGzRnaZnsPZ5riL0fXUUFxoJqOpYHwzNLHArztWU5pK2emdvdDI6MnwOFOYdWmqaQ/WFV8YwxtC5roz2Xcl1tH3h1k1PS1G1iGRwilHa1xx7tx8lqfSJUdRoitAODKWRjzcPgFiHhxWo9I1cX6JtLCfWqXMkPfhmfzIWGugDqqJ42nyzWxhlUW0NRGdQGX3yWa0VZNb6+CrpzsywPD2nvC9C2y4Q3W109dAcxzsDx3do8juXnNab0U3zLKiyzO3jM0Gez7Q/I+1MXp+sjEo1t8k6PVnVTmB2p3n/K0lUfpWs9BW6PmuFRhlTRYdDIOJJIGwe45VqvN5o7Da5bhXOe2nixtFjC47+G4LKtZ69s2rG2u20808NH6U2SsfJGRhg7hnPEnyCpk72hpadZXWMHpqh9QyaMHRacyBuzI+4y+6oFbZbnbqWGpraCemgqADHI9uGuyMjB8Fp+gejOhms7Ljf6br5KjD4YS4gMZyJxxJ4+GF9/SnPSXLo1hqqKRk1N6RGY3s4Y3t+Kv1GwRUFPGBubG1o8gteKna2Q3zUxiON1EtG0t7Bc4g2vfK3vmvzjiorNbSIYoqSkp2Fxaxoa1oG87gsDvt1kvd7qbhJkGZ/qj7rRuaPYtL6Ub56HZ47VC7EtZvkxyjH9T+RWSK74NTaDDMduQ4LivSOtMsogB1ZnifnNa50T1G3puqhP6qoJ8i0f0Ko2ur069aoqCHkwUxMMQ5YB3nzOfcrJ0U1ZjivEIO8MZKPIOH9FnTnFznOPFxyVnpoQKyV52W5rVrKlxw6CMbb3+xsv5Vq0noar1Kw1UknotEDjrCMueeeyPiqqeC9EWSnipbDQwwtAjZAzGPAb17xOrfTxjq9ZWPBKCOslcZdTdm9VhvRVYhHh01a533usA92FWNSdGdXbKd9XbJnVkDBl8bhiRo7Rj6S11Qq9HiVRG7SLr8VbpsGo5WaIZY7wvNKu3Rpbbr+kMVwgge2hDXMlkdua4EcB278K9/wBn9gN6kuL6Zzy9211JPzQdzOz8OCsjGNjYGMaGsaMBoGAApCrxZskZjjbrGd1EUGAPhmEsrvpOVtqlSiKvq3qF89db6S5Urqetp46iJ3Fr25/8L6UX0Eg3C+FocLHUuVa7TNaJOpgrHy0GPVhm9Z0R7Gv47Pcc+K6ilF9c4uNyvLGBg0W6kREXle0RERERFCIiKVCIilQpRFg+uPrvc/3o/lC4PJd7XH13uf70fyhcDiFfqb8FnAeS5NW/mZP3HzXoiyfV+3/5aP8AlC+5ZzbulK20lspaZ9BVF8MTYyRs4JAA7V+0nS3bg0mO21Tncg5zQPiqi6gqS42YV0GPFqJrADINXer5UVEVJTSVE7wyKJpe5x5ALzrXVHplxqanGOuldJjxJKsOpdd3HUUJpthtJRk5MTDkv/aPPwVXU/hlE6mBdJrKqmNYkysc1kX0t271/UcT5pmRRjL5HBrQOZJwFeulCTqZ7TbQ7PotNk+eB/tTo40rNWV8d5q4iylgO1CHD+8fyI7h+a4/SBWem61rSDlsOzCP9I3+/K9mRs1Y1rf0A+JyWIQup8Pc9+XWEAcBndVpfbaLlLZ7xTXCH6cDw7H3hzHmMhfKI3mHrdg9XtbO1jdnGcL+VIuAeC06lDNc6Nwc3IjNeiHxUF/s7BNEyqoqpjX7DhkOG4jK/qmtNuo4wymoKaBo5RxNb8FS+iy+elWya0TOzJSnbizzYTvHkfzV/VCqYOolLDsXWaKsNTTte05HZ37Vl0/R1e9QXqqFzulXTWdsh6qKSfrpJBn6WB6rR2dit1j0qNNSumbfblU0zYyDDVSh8YHbwyMdysapvSVfPkzT3oUTsT1xLN3EMH0j57h5rDTUgklDW6ypHEMambTEyEBrRqAHy53rMdTXl1/1DU1xz1bnbMQPJg3D+vmuSpU7DjGZNk7AOyXcs9nuXQmMEbQwaguLySOleXu1nNXPotnDNUy07j6tRTubjtwQf6qqXOjfb7rVUcgw6CVzD5Hcupoiq9E1pbZCcB0nVn/UCPirj0l6Uknd8uUMZe5rcVLGjfgcH/AqOdM2Css7U8DxCmGU7qnDtJmZjcfAgLMFrXR9rGnq7fDaK6VsVXANiJzjgStHAZ7RwwslU8DkLaq6VtUzQd9lpUFdJQy9YzPeN69KosVsXSJeLOGwzOFfTN3bEp9YDudx9uVo1j13Zb4Wxtn9FqXfqZ/VJPceBVUqMPngzIuN4V9o8YpqqwBs7cfmasqhSmVHqXRFClEUKVClEUKcIiIiIiIiIiIiYRERFClERQpUKURYPrj673P96P5QuCu/rj67XP8Aej+ULgHgr9Tfgs4DyXJqz8zJ+4+aItus2krBNY6GWS1Uz5HwMc5xbkkloJK+qTROm5WlrrTAP2ctPuKizjMQNi08lON6NzuaHB4z4+ywdftSTilrYpzDHOI3BxjkGWu7iOxadfOiukkgdLZpnwzAZEMrtpju7PEe9ZjVUlRQ1UlNVROhmiOy5jhggrfp6qKqB0D9tqiaugqKFwMg4HYtr0zq6kvlkqKoQ+iuom/Ox59VoxkEHs3H2LE6qofVVs9RIcvme6Q+JOVdGN/R7opkefVqbzJgdvV/+Af/AJKjLWw+Bkb5HM1XsPtr5rexaqkmjhZL9QFz99XLzWjaa0y28dGFWwM/4iaZ00J/E0AD24I81nJaWuLXAgg4IPJegNL0Hybpa30pGHMhBd+0d595WW9I1i+SdRmqiZimrsyDHAP+0Pj5rXoKzTqHxnUSSPnBbeK4d1dJFM0ZtAB+cVxNOXd1iv8AS17SdhjsSAc2Hc4ez8l6AjkZNEyWNwcx4DmuHAg8CvNi2Lozvfyhp40Er8z0J2RniWH6Ps3jyC84xT3aJhsyK99HKzRe6mdtzHHby8lczgAknAHNYPrC+G/alqKljswRnqof2Rz8zk+a07pCvvyPpl8Ub9mprcxMxxA+0fZu81ii8YPT5GY8B6r30krLltM3ifRMLQL5pr5H6LaYyMxU+kNnmPMFwIx5AgLkdH9i+WdSsklZmmo8SyZ4E/ZHt3+S1PV9EbhpC4wAZd1Re0d7fWH5LPXVmhPHENhBK1sLw7rKWWdwzIIHzjl4rB6ad1NVw1DNzontePEHK9HQSsqaaOZhBZK0OHeCMrzatw6P7kLjo6lBdmSmzA/y4e7Cx41HdjZBsy8Vl6NT2kfCdov4f+rkao6NKe4PfV2hzKWodvdCd0bz3fdPuWZXO0V9nqTBX0skD+W0NzvA8CvRK/GsoqW4UzoKyCOeJ3FsjchaFLissPZf2hzUtXYDDUEvi7LuXh7Lzgi1G/dFkEodNZZupfx6iU5afB3EeeVnFwttZaqx1LXU74Jm/ZcOI7QeYVjp6yKoHYOe7aqbWYdUUZ/yjLeNSsWmtf3KxvZBUudW0I3Fjzl7B+E/A+5a/bblS3egjrKKUSwyDcRxB5gjkV50Vu6O9QSWnUDKOR59ErSGOBO5r/su+Hmo/EMPY9pljFiOal8HxeSKQQTG7TkO7+FtChFKqqvqhSoUoiJhEREREREREREREREUKVGURSihSiLCNb/Xa5/vR/KFwTwK72t/rtc/3o/lC4J4K/U34LOA8lyWs/MyfuPmvQ1i+rtu/wAtH/KF9+F8Fi+rtu/y0f8AKF9yokn1FdVh/DbwClVbV2i4dTTUs7HtgnjeGyPx9OPO8eI5K0Koa91a2x251FSSA3CobgY/VNP2j39izUglMoEOta2IGAU7jUfT81d6oWvbxHcL6KOlwKK3t6iIDhkcSPYB5Ll6atZvGpKKjxlj5AX/ALI3n3Bcskk7960roosx2qq8SN3f3EWfa4/kParZOW0dKQ3YLDj8zVApWuxGuBdtNzwHyy0rGNwXB1nYhftNzwMbmoi+dh/aHLzGQu8ipsbzG4PbrC6RNE2aMxv1HJeayMHB3ELuaOvRsWpqepc7EEh6qb9k8/I4Pkvt6QbF8j6kfLE3FNWZlZjgHfaHt3+aqqvLSyqhvscFyx7ZKGpt+ph+eKsmur4L5qWV0T9qmpvmYscDji7zPuwq4is+gbD8takjdKzapqTEsmeBP2W+Z/IodCkh7mj54r6BJX1P/wBPPzwWl6HsPyFpqJkjdmpqPnpu0E8G+Q+KsTmtewtcMtcMEKVCo8kjpHl7tZXUYYWwxtiZqAsvO95oHWu9VlE4Y6iVzB3jO4+zCtvRdehRXuW2yuxHWjLM/fH9Rn2Bfp0qWg093gujG/N1Terefxt4e0fkqLDNJTzsmieWSRuDmuHEEbwVcGgVtLY7Rz/9XOHl2GV5I/SeR/hekkXB0nqWHUtobMCG1UYDZ4/uu7R3Fd1U6SN0bixwzC6RFKyZgkYbgqVxdUadp9R2eSnka0VDQXQS43sd/Q812Uzgb+CMe6Nwc05hfZYmysMbxcFebJI3xSOjkGy9hLXDsIUse6KRsjDhzCHA94X1XeaOovddNH/dyTvc3HYXHC+PBO4cSugNOk0ErkThovIbsK9H0s3pFHBN/wC5G1/tGV+q/CgiMFtponcY4mtPkAF9C567Xkuvsvoi6hSoUr4vSImVCIpRERERERERFCIpUKVCIpRQiIsJ1v8AXa5/vR/KFwTwXe1v9drn+9H8oXBV+pvwWcB5LktZ+Zk/cfNafbulC10drpaaShqy+GJsZLdnBIAG7evoPSzaserb6wnv2R8VlCLSOFUxNyD4qSbj1Y0BoI8FoF26VqyoidHbKNlJnd1sjttw8Bw/NUOeomqp3z1ErpZZDtOe85JK/NfrT009ZUMgponzTPOGsYMkrbhpoacHqxZR9RWVFY4da6+4fwv7oKGe5V8NHTN25pnBrR8fBegLRbIbPaKegg+hAwNz948z5neq3obRf6PwmtrQ11wlbjA3iJvYO/tKuCrWJ1gneGM+kcyrtgeGmkjMso7TuQRSoRRCsSr2uLF8u6amZG3aqaf56HtJHEeY+CwxelFiWvrF8iakkdE3ZpqvM0eOAP2m+R/MKw4PUZmB3Eeqp/SOjuBVN4H0Pp4KsLcdDWL5C03E2RuKmp+dl7QTwb5D4rNdA2H5b1HG+Vu1TUmJZM8Cfst8z+RW2r7jFTmIG8T6L50corA1TuA9T6eKlFCKuq4rl6kssd/sNRQuwHuG1E4/ZeOB+HmsDqKeWkqZKedhjlicWPaeIIXpFUnXOiPlxpuNva1teweuzgJgP9ymcMrRA7q5PpPIqt45hjqpomiHaGzePcLLbVd6yy17KyhlMcrdx5hw7COYWo2XpOtVbE1tya6gn5nBdGfAjePNZJNBLTTvhnjdFKw4cx4wQfBfxyU9UUUNVm7XvCqVHiVRQktYctxW9O1lp1rNs3ilx3PyfZxVQ1Z0kU89BLQWUvcZQWPqHDZAHPZHHPes0RasOEwxu0iSVv1HSCpmYWNAbfdrUcF3NIWl161PSU2zmNjhLL3NbvPt3DzXMoaGpuVWylo4XzTPOA1o9/cFtOjtKR6Ztx2y2StnwZnjgOxo7h71mxCrbTxkA9o6vda2E4e+rmDiOwNZ9FZEUKVTF0tQpUIiKUUIiKUREREREREyijCIilFCIpyijCnkiKqXbo9s94uk1fPJVRyzEFwjeAM4xneCvj/sqsX+Irv4jf8ApV2UrbbW1DQGh5sFHvw2ke4udGLlUj+yqx/4iu/iN/6U/sqsf+Irf4jf+lXdQvv9dU/7lef7VR/9YVOh6MNPxuBf6VNjk+XA9wCsdssdss8ZbQUUVPni5o9Y+JO8r78KFikqJZRZ7iVnho6eA3jYAeClQinCwLbRFClEUKva1067UVhMUDWmrhd1kOTjJ5jPePgrEoWSOR0Tw9usLDNC2eMxP1FcDRmnv0csLIJQ30qU9ZOQc7+Qz3D4rvphSvkkjpHl7tZX2GJsMYjZqCKEReFlRFKhEXKvOmbTfm/8dStfIBgSt9V48x8VTazokic4miuj2Dk2aPa94I/JaPhStqGsnhFmOyWhUYdS1JvKwE79R5LKh0SXDa33Kmx27Dl0aHolpmODq65SSjm2FgZ7zlaGpws7sTqXC2lyC1WYHQsN9C/Elc60WK22OAxW+lZCD9J3FzvEneV0UULQc4uOk43KlmMbG0NYLBFKIvK9qFKhSiIiKERSiIiIoUqERSihMIiIiIiImFKIihMKcIihSoU4RFGUTCIilQpwmERQpUIiIpUIiIiJhEUqFOFGERFKYUYREUphMIiKMoiIiJhERFKYREUIiIiIiYRFKKFOERf/2Q==';
let session=null,profile=null,tab='dashboard',assignments=[],barns=[],items=[],suppliers=[],employees=[],advances=[],pplUsers=[],contracts=[],contractReadiness=[];
let navInitialCollapsePending=true;
const esc=x=>String(x??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const fmtNumber=v=>{
  if(v===null||v===undefined||v==='') return '';
  const n=Number(v);
  if(!Number.isFinite(n)) return esc(v);
  const dec=Math.abs(n-Math.trunc(n))>1e-9;
  return new Intl.NumberFormat('id-ID',{minimumFractionDigits:dec?2:0,maximumFractionDigits:dec?2:0}).format(n);
};
const autoCodeTabs=new Set(['kandang','item','supplier','karyawan']);
const shortBarnName=name=>{
  const n=String(name||'').trim();
  return n.replace(/^Internal\s+/i,'Int.');
};
const shortBarnLabel=b=>b?(shortBarnName(b.name)||b.name):'-';
const shortContractLabel=name=>String(name||'').replace(/^Kontrak\s+/i,'').trim();
const assignmentIdentity=(rows,barnRows,contractRows,a)=>{
  if(!a)return '-';
  const b=(barnRows||[]).find(x=>x.id===a.barn_id),k=(contractRows||[]).find(x=>x.id===a.master_contract_id);
  const cycle='Siklus '+(assignmentCycleNo(rows,a)||'-');
  return (b?shortBarnLabel(b):'-')+' · '+cycle+' · '+(shortContractLabel(k?.number)||'-');
};
const assignmentActiveBarnLabel=(barnRows,a)=>{
  const b=a&&(barnRows||[]).find(x=>x.id===a.barn_id);
  return b?shortBarnLabel(b):'-';
};
const assignmentLabel=id=>{const a=assignments.find(x=>x.id===id);return assignmentIdentity(assignments,barns,contracts,a)};
const assignmentCycleNo=(rows,a)=>{
  if(!a)return 0;
  const same=(rows||[]).filter(x=>x.barn_id===a.barn_id).slice().sort((x,y)=>{
    const xd=String(x.start_date||x.created_at||''),yd=String(y.start_date||y.created_at||'');
    return xd.localeCompare(yd)||String(x.created_at||'').localeCompare(String(y.created_at||''))||String(x.id||'').localeCompare(String(y.id||''));
  });
  const idx=same.findIndex(x=>x.id===a.id);
  return idx>=0?idx+1:0;
};
const assignmentCycleLabel=(rows,a)=>'Siklus '+(assignmentCycleNo(rows,a)||'-');
const cellValue=(row,f)=>f[2]==='number'?fmtNumber(row[f[0]]):f[2]==='supplier'?esc(suppliers.find(s=>s.id===row[f[0]])?.name||''):f[2]==='assignment'?esc(assignmentLabel(row[f[0]])):esc(row[f[0]]);
const formatInputID=v=>{
  let s=String(v??'').replace(/\s/g,'').replace(/\./g,'').replace(/[^0-9,]/g,'');
  let [i,d]=s.split(',');
  i=(i||'0').replace(/^0+(?=\d)/,'');
  i=i.replace(/\B(?=(\d{3})+(?!\d))/g,'.');
  if(d!==undefined) return i+','+d.slice(0,2);
  return i;
};
const normalizeInputID=v=>{
  const s=String(v??'').trim().replace(/\./g,'').replace(',','.');
  if(s==='') return null;
  const n=Number(s);
  return Number.isFinite(n)?n:null;
};
const bindItemUnit=()=>{
  if(tab!=='item')return;
  const form=document.getElementById('entry');
  if(!form)return;
  const cat=form.elements.category;
  const unit=form.elements.unit;
  if(!cat||!unit)return;
  if(!document.getElementById('ovk-units')){
    const dl=document.createElement('datalist');
    dl.id='ovk-units';
    ['BOTOL','SACHET','LITER','ML','GRAM','KG','VIAL','AMPUL','TABLET','DOS'].forEach(v=>{
      const o=document.createElement('option');o.value=v;dl.appendChild(o);
    });
    form.appendChild(dl);
  }
  const sync=()=>{
    unit.removeAttribute('list');
    unit.placeholder='';
    if(cat.value==='DOC'){
      unit.value='EKOR';
      unit.readOnly=true;
    }else if(cat.value==='PAKAN'){
      unit.value='ZAK';
      unit.readOnly=true;
    }else if(cat.value==='OVK'){
      if(unit.readOnly)unit.value='';
      unit.readOnly=false;
      unit.setAttribute('list','ovk-units');
      unit.placeholder='Pilih/ketik satuan OVK';
    }else{
      if(unit.readOnly)unit.value='';
      unit.readOnly=false;
      unit.placeholder='Masukkan satuan';
    }
  };
  cat.addEventListener('change',sync);
  sync();
};
const bindComputedWeights=()=>{
  const form=document.getElementById('entry');
  if(!form)return;
  const show=(key,val)=>{
    const el=form.querySelector('[data-computed="'+key+'"]');
    if(el)el.value=val==null||!Number.isFinite(val)?'':new Intl.NumberFormat('id-ID',{minimumFractionDigits:2,maximumFractionDigits:2}).format(val);
  };
  const calc=()=>{
    if(tab==='recording'){
      const n=normalizeInputID(form.elements.sample_count?.value);
      const w=normalizeInputID(form.elements.sample_weight_total_kg?.value);
      show('avg_weight_kg',n>0&&w!=null?w/n:null);
    }else if(tab==='chick_in'){
      const n=normalizeInputID(form.elements.sample_count?.value);
      const w=normalizeInputID(form.elements.sample_weight_total_g?.value);
      show('avg_weight',n>0&&w!=null?w/n:null);
    }else if(tab==='panen'){
      const n=normalizeInputID(form.elements.birds?.value);
      const w=normalizeInputID(form.elements.net_weight_kg?.value);
      show('avg_weight_kg',n>0&&w!=null?w/n:null);
    }
  };
  form.querySelectorAll('input').forEach(el=>el.addEventListener('input',calc));
  calc();
};
const bindNumberInputs=()=>{
  root.querySelectorAll('input[data-number="1"]').forEach(el=>{
    el.addEventListener('input',()=>{el.value=formatInputID(el.value)});
    el.addEventListener('blur',()=>{
      if(el.value.includes(',')){
        const [i,d='']=el.value.split(',');
        el.value=i+','+(d+'00').slice(0,2);
      }
    });
  });
};



const txnListState=(rows,key,dateKey,size=5,barns=null,barnKey='barn_id',opts={})=>{
  window.__bmsTxnList=window.__bmsTxnList||{};
  const st=window.__bmsTxnList[key]||{from:'',to:'',barn:'',assignment:'',status:'',page:0};
  if(st.assignment===undefined)st.assignment='';
  if(st.status===undefined)st.status='';
  if(!st.barn)st.assignment='';
  const filtered=rows.filter(x=>
    (!st.barn||String(x?.[barnKey]||'')===st.barn)&&
    (!opts.assignmentKey||!st.assignment||String(x?.[opts.assignmentKey]||'')===st.assignment)&&
    (!opts.statusKey||!st.status||String(x?.[opts.statusKey]||'')===st.status)&&
    (!st.from||String(x?.[dateKey]||'')>=st.from)&&
    (!st.to||String(x?.[dateKey]||'')<=st.to)
  );
  const pages=Math.max(1,Math.ceil(filtered.length/size));
  if(st.page>=pages)st.page=pages-1;if(st.page<0)st.page=0;
  window.__bmsTxnList[key]=st;
  const pplFilter=profile?.role==='PPL';
  const allBarnLabel=pplFilter?'Semua Kandang Saya':'Semua Kandang';
  const allCycleLabel=pplFilter?'Semua Siklus Saya':'Semua Siklus';
  const barnControl=barns?'<label>Pilih Kandang<select data-txn-barn="'+key+'"><option value="">'+allBarnLabel+'</option>'+barns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc((b.code?b.code+' · ':'')+(b.name||''))+'</option>').join('')+'</select></label>':'';
  const cycleRows=(opts.assignments||[]).filter(a=>!st.barn||!a.barn_id||String(a.barn_id)===String(st.barn));
  const assignmentControl=opts.assignments?.length?'<label>Pilih Siklus<select data-txn-assignment="'+key+'" '+(!st.barn?'disabled':'')+'><option value="">'+allCycleLabel+'</option>'+cycleRows.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(a.label||a.id)+'</option>').join('')+'</select></label>':'';
  const statusControl=opts.statusOptions?.length?'<label>Status<select data-txn-status="'+key+'"><option value="">Semua Status</option>'+opts.statusOptions.map(v=>'<option value="'+esc(v)+'" '+(st.status===v?'selected':'')+'>'+esc(v)+'</option>').join('')+'</select></label>':'';
  return {key,st,pages,total:filtered.length,rows:filtered.slice(st.page*size,(st.page+1)*size),assignmentOptions:opts.assignments||[],
    controls:'<div class="form-vertical compact-form" style="margin-bottom:12px">'+barnControl+assignmentControl+statusControl+'<label>Tanggal Dari<input type="date" data-txn-from="'+key+'" value="'+esc(st.from||'')+'"></label><label>Tanggal Sampai<input type="date" data-txn-to="'+key+'" value="'+esc(st.to||'')+'"></label><div class="inline-actions"><button type="button" data-txn-search="'+key+'">Cari</button><button type="button" data-txn-reset="'+key+'">Reset</button></div></div>',
    pager:'<div class="inline-actions" style="margin-top:12px"><button type="button" data-txn-prev="'+key+'" '+(st.page<=0?'disabled':'')+'>Sebelumnya</button><span class="muted">Halaman '+(st.page+1)+' / '+pages+' · '+filtered.length+' data</span><button type="button" data-txn-next="'+key+'" '+(st.page>=pages-1?'disabled':'')+'>Selanjutnya</button></div>'};
};
const bindTxnList=(x,render)=>{
  const barn=root.querySelector('[data-txn-barn="'+x.key+'"]'),assignment=root.querySelector('[data-txn-assignment="'+x.key+'"]'),status=root.querySelector('[data-txn-status="'+x.key+'"]'),from=root.querySelector('[data-txn-from="'+x.key+'"]'),to=root.querySelector('[data-txn-to="'+x.key+'"]'),search=root.querySelector('[data-txn-search="'+x.key+'"]'),reset=root.querySelector('[data-txn-reset="'+x.key+'"]'),prev=root.querySelector('[data-txn-prev="'+x.key+'"]'),next=root.querySelector('[data-txn-next="'+x.key+'"]');
  if(barn&&assignment)barn.onchange=()=>{
    const bid=barn.value||'';
    const rows=x.assignmentOptions.filter(a=>!bid||!a.barn_id||String(a.barn_id)===String(bid));
    assignment.disabled=!bid;
    assignment.innerHTML='<option value="">'+(profile?.role==='PPL'?'Semua Siklus Saya':'Semua Siklus')+'</option>'+rows.map(a=>'<option value="'+esc(a.id)+'">'+esc(a.label||a.id)+'</option>').join('');
  };
  if(search)search.onclick=()=>{x.st.barn=barn?.value||'';x.st.assignment=x.st.barn?(assignment?.value||''):'';x.st.status=status?.value||'';x.st.from=from?.value||'';x.st.to=to?.value||'';if(x.st.from&&x.st.to&&x.st.from>x.st.to){const t=x.st.from;x.st.from=x.st.to;x.st.to=t}x.st.page=0;render()};
  if(reset)reset.onclick=()=>{x.st.barn='';x.st.assignment='';x.st.status='';x.st.from='';x.st.to='';x.st.page=0;render()};
  if(prev)prev.onclick=()=>{x.st.page=Math.max(0,x.st.page-1);render()};
  if(next)next.onclick=()=>{x.st.page=Math.min(x.pages-1,x.st.page+1);render()};
};
const roles={kandang:['ADMIN'],liga_abk:['ADMIN','PPL'],rekap_produksi:['ADMIN','PPL'],item:['ADMIN'],supplier:['ADMIN'],supplier_sapronak:['ADMIN'],supplier_daging:['ADMIN'],kontrak:['ADMIN'],harga_hidup:['ADMIN'],bonus_kontrak:['ADMIN'],standar_performa:['ADMIN'],chick_in:['ADMIN','PPL'],sapronak:['ADMIN','LOGISTIK'],recording:['ADMIN','PPL'],kunjungan:['ADMIN','PPL'],panen:['ADMIN','MARKETING'],ekspedisi:['ADMIN','LOGISTIK','MARKETING'],estimasi:['ADMIN','PPL'],rhpp:['ADMIN','KEUANGAN'],finance_rhpp_real:['ADMIN','KEUANGAN','OWNER'],bop:['ADMIN','KEUANGAN'],bop_umum:['ADMIN','KEUANGAN'],arus_kas:['ADMIN','KEUANGAN'],laporan_keuangan:['ADMIN','KEUANGAN'],perusahaan:['ADMIN'],karyawan:['ADMIN'],kasbon:['ADMIN','KEUANGAN'],cicilan:['ADMIN','KEUANGAN'],gaji_abk:['ADMIN','KEUANGAN'],expedisi_usaha:['ADMIN','LOGISTIK'],bop_expedisi:['ADMIN','KEUANGAN']};
const visibleTabs={
  ADMIN:['dashboard','kandang','item','supplier_sapronak','supplier_daging','kontrak','harga_hidup','bonus_kontrak','standar_performa','reset_klasemen','karyawan','pengguna','perusahaan','logistik_kontrak','logistik_pengiriman','logistik_kiriman_luar','logistik_retur_luar','logistik_retur','logistik_laporan','chick_in','recording','kunjungan','estimasi','liga_abk','rekap_produksi','ppl_rhpp_view','laporan','marketing_panen_kontrak','marketing_tambah_daging','marketing_laporan','rhpp','rhpp_history','finance_rhpp_real','bop','bop_umum','expedisi_usaha','bop_expedisi','gaji_abk','kasbon','cicilan','arus_kas','laporan_keuangan','owner_logistics_report','owner_marketing_report','owner_finance_report','owner_production_report','owner_ppl_report','arsip_data','profil'],
  LOGISTIK:['dashboard','logistik_kontrak','logistik_pengiriman','logistik_kiriman_luar','logistik_retur_luar','logistik_retur','expedisi_usaha','logistik_laporan','profil'],
  PPL:['dashboard','kandang','kontrak','harga_hidup','bonus_kontrak','standar_performa','chick_in','recording','kunjungan','estimasi','liga_abk','rekap_produksi','ppl_rhpp_view','laporan','profil'],
  MARKETING:['dashboard','kandang','kontrak','harga_hidup','marketing_panen_kontrak','marketing_tambah_daging','marketing_laporan','profil'],
  KEUANGAN:['dashboard','rhpp','finance_rhpp_real','bop','bop_umum','bop_expedisi','gaji_abk','kasbon','cicilan','arus_kas','laporan_keuangan','profil'],
  OWNER:['dashboard','finance_rhpp_real','owner_logistics_report','owner_marketing_report','owner_finance_report','owner_production_report','owner_ppl_report']
};
const canViewTab=k=>k==='profil'||(profile?.role&&visibleTabs[profile.role]?.includes(k));
const modules={
  kandang:{table:'barns',fields:[['name','Nama'],['capacity','Kapasitas','number'],['kind','Jenis','select:OPEN_HOUSE,SEMI_CLOSE_HOUSE,CLOSE_HOUSE'],['location','Lokasi']]},
  item:{table:'items',fields:[['name','Nama'],['category','Kategori','select:DOC,PAKAN,OVK,LAINNYA'],['feed_phase','Fase Pakan'],['unit','Satuan'],['supplier_id','Supplier','supplier'],['kg_per_unit','Kg / Satuan','number']]},
  supplier:{table:'suppliers',fields:[['name','Nama Supplier'],['address','Alamat'],['phone','Telepon/WhatsApp'],['contact_person','Kontak Person'],['bank_name','Bank'],['bank_account_number','No. Rekening'],['bank_account_name','Atas Nama Rekening'],['tax_number','NPWP'],['business_id','NIB/No. Usaha'],['notes','Catatan']]},
  kontrak:{table:'contracts',fields:[['number','Nomor Kontrak'],['contract_date','Tanggal','date'],['integrator','Perusahaan Inti'],['doc_price','Harga DOC (Rp/ekor)','number'],['pre_starter_price','Harga Pre Starter (Rp/kg)','number'],['starter_price','Harga Starter (Rp/kg)','number'],['finisher_price','Harga Finisher (Rp/kg)','number'],['ovk_price_basis','Dasar Harga OVK','select:FIXED,DISTRIBUTOR_PLUS_VAT'],['ovk_price','Harga OVK Tetap (Rp)','number'],['ovk_vat_percent','PPN OVK (%)','number'],['harvest_price','Harga Panen Dasar (Rp/kg)','number'],['signed_reference','Referensi Kontrak Ditandatangani']]},
  harga_hidup:{table:'contract_live_prices',fields:[['contract_id','Kontrak','contract'],['min_weight_kg','Bobot minimum (kg)','number'],['max_weight_kg','Batas atas bobot, tidak termasuk (kg)','number'],['price_per_kg','Harga per kg (Rp)','number']]},
  bonus_kontrak:{table:'contract_bonuses',fields:[['contract_id','Kontrak','contract'],['metric','Dasar bonus','select:IP,FCR_DIFFERENCE,DEPLETION,OTHER'],['min_value','Batas minimum','number'],['max_value','Batas maksimum','number'],['rupiah_per_kg','Tambahan Rp/kg','number'],['notes','Keterangan']]},
  standar_performa:{table:'performance_standards',fields:[['contract_id','Kontrak','contract'],['age_days','Umur (hari)','number'],['std_feed_g_per_bird','Standar Pakan (g/ekor)','number'],['std_body_weight_g','Standar BW (g)','number'],['std_fcr','Standar FCR','number']]},
  chick_in:{table:'chick_ins',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['arrived_on','Tanggal Datang','date'],['hatchery','Hatchery'],['strain','Strain'],['shipped','Jumlah Dikirim','number'],['received','Jumlah Diterima','number'],['doa','DOA','number'],['sample_count','Jumlah Sampel DOC','number'],['sample_weight_total_g','Total Bobot Sampel DOC (g)','number'],['avg_weight','Bobot Rata-rata DOC (g)','computed'],['delivery_number','Nomor DO']]},
  sapronak:{table:'supplies',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['item_id','Item','item'],['quantity','Jumlah','number'],['received_on','Tanggal','date'],['delivery_number','Nomor DO']]},
  recording:{table:'recordings',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['recorded_on','Tanggal','date'],['age_days','Umur (hari)','number'],['mortality','Mortalitas','number'],['culling','Afkir','number'],['feed_kg','Pakan (kg)','number'],['feed_item_id','Jenis Pakan','item'],['feed_bags_in','Zak Masuk','number'],['feed_bags_out','Zak Keluar','number'],['feed_bags_balance','Sisa Zak','number'],['sample_count','Jumlah Sampel','number'],['sample_weight_total_kg','Total Bobot Sampel (kg)','number'],['avg_weight_kg','Bobot Rata-rata (kg)','computed'],['actual_fcr','FCR Aktual','number'],['ip','IP Aktual','number'],['temperature','Suhu','number'],['humidity','Kelembapan','number'],['medication_notes','Program Obat'],['notes','Catatan']]},
  kunjungan:{table:'visits',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['visited_on','Tanggal Kunjungan','date'],['findings','Temuan'],['recommendation','Rekomendasi'],['follow_up','Tindak lanjut'],['follow_up_status','Status']]},
  panen:{table:'harvests',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['harvested_on','Tanggal Panen','date'],['transaction_number','Nomor Transaksi'],['delivery_number','Nomor DO'],['birds','Jumlah Ekor','number'],['net_weight_kg','Berat Bersih (kg)','number'],['avg_weight_kg','Bobot Rata-rata (kg)','computed'],['price_per_kg','Harga per kg','number'],['buyer','Pembeli'],['vehicle','Kendaraan'],['driver','Sopir']]},
  rhpp:{table:'rhpp_real',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['amount','RHPP Real (Rp)','number'],['received_on','Tanggal Diterima','date'],['reference','Referensi'],['notes','Catatan']]},
  bop:{table:'bop',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['incurred_on','Tanggal','date'],['category','Kategori','select:OVK,TENAGA_KERJA,TRANSPORTASI,LISTRIK,PERBAIKAN,EKSPEDISI,LAINNYA'],['amount','Nominal (Rp)','number'],['reference','Referensi'],['notes','Catatan']]}
  ,ekspedisi:{table:'expeditions',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['departed_on','Tanggal','date'],['destination','Tujuan'],['vehicle','Kendaraan'],['driver','Sopir'],['cargo','Muatan'],['reference','Referensi'],['notes','Catatan']]}
  ,estimasi:{table:'rhpp_estimates',fields:[['contract_assignment_id','Kandang / Kontrak Logistik','assignment'],['estimated_on','Tanggal Estimasi','date'],['age_days','Umur (hari)','number'],['projected_amount','Proyeksi RHPP','number'],['notes','Catatan']]}
  ,perusahaan:{table:'company_profile',fields:[['company_name','Nama Perusahaan'],['legal_name','Nama Legal'],['address','Alamat'],['phone','Telepon'],['email','Email'],['website','Website'],['tax_number','NPWP'],['business_id','Nomor Usaha'],['signatory_name','Penandatangan'],['signatory_title','Jabatan']]}
  ,karyawan:{table:'employees',fields:[['name','Nama'],['kind','Jenis','select:KARYAWAN,ABK'],['phone','Telepon'],['job_title','Jabatan'],['joined_on','Tanggal Masuk','date'],['notes','Catatan']]}
  ,kasbon:{table:'advances',fields:[['employee_id','Karyawan','employee'],['advanced_on','Tanggal Kasbon','date'],['amount','Nominal','number'],['description','Keterangan'],['reference','Referensi']]}
  ,cicilan:{table:'advance_payments',fields:[['advance_id','Kasbon','advance'],['paid_on','Tanggal Bayar','date'],['amount','Nominal','number'],['method','Metode'],['reference','Referensi'],['notes','Catatan']]}
};
const title={dashboard:'Dashboard',reset_klasemen:'Reset Klasemen ABK',owner_logistics_report:'Laporan Logistik',owner_marketing_report:'Laporan Marketing',owner_finance_report:'Laporan Keuangan',owner_production_report:'Laporan Produksi',owner_ppl_report:'Laporan PPL',supplier_sapronak:'Master Supplier Sapronak',supplier_daging:'Master Supplier Daging',logistik_kontrak:'Buat Kontrak',logistik_pengiriman:'Pengiriman',logistik_kiriman_luar:'Sapronak Luar',logistik_retur:'Retur RHPP',logistik_retur_luar:'Retur Tambah Sapronak',logistik_laporan:'Laporan Logistik',marketing_panen_kontrak:'Panen Kontrak',marketing_tambah_daging:'Tambah Daging',marketing_laporan:'Laporan Marketing',kandang:'Master Kandang',item:'Master Sapronak',supplier:'Master Supplier',kontrak:'Master Kontrak',harga_hidup:'Harga Ayam Hidup',bonus_kontrak:'Bonus Kontrak',standar_performa:'Master Performa',chick_in:'Chick-In / DOC Masuk',sapronak:'Sapronak',recording:'Recording PPL',kunjungan:'Kunjungan PPL',panen:'Panen',ekspedisi:'Ekspedisi',estimasi:'Estimasi',liga_abk:'Liga ABK',rekap_produksi:'Rekap Produksi PPL',ppl_rhpp_view:'Lihat RHPP',rhpp:'CEK RHPP',rhpp_history:'Cetak RHPP',finance_rhpp_real:'RHPP Real',bop:'BOP Kandang',bop_umum:'BOP Umum',expedisi_usaha:'Expedisi Usaha',bop_expedisi:'BOP Expedisi',gaji_abk:'Gaji ABK',arus_kas:'Arus Kas',laporan_keuangan:'Laporan Keuangan',perusahaan:'Data Perusahaan',karyawan:'Master Karyawan',kasbon:'Kasbon',cicilan:'Cicilan',laporan:'Laporan',pengguna:'Master Pengguna',arsip_data:'Arsip Data',profil:'Profil'};
const msg=(s,ok=false)=>{let e=document.getElementById('message');if(e){e.textContent=s;e.className=ok?'success':'error'}};
async function start(){
  login();
  try{
    const sessionResult=await Promise.race([
      db.auth.getSession(),
      new Promise((_,reject)=>setTimeout(()=>reject(new Error('Pemulihan sesi terlalu lama')),5000))
    ]);
    session=sessionResult?.data?.session||null;
    if(!session)return;
    const r=await db.from('profiles').select('role,full_name,active').eq('user_id',session.user.id).single();
    profile=r.data;navInitialCollapsePending=true;
    if(!profile?.active){
      root.innerHTML='<main class="login"><h1>Akses belum aktif</h1><p>Administrator perlu membuat profil role untuk akun Anda.</p><button id="logout">Keluar</button></main>';
      document.getElementById('logout').onclick=logout;
      return;
    }
    await render();
  }catch(error){
    login();
    msg('Koneksi awal gagal: '+(error?.message||'tidak diketahui')+'. Silakan coba masuk kembali.');
  }
}
function login(){root.innerHTML='<main class="login"><h1>BMS Mobile</h1><p>Masuk dengan akun yang diberikan Administrator.</p><form id="auth"><label>Email<input name="email" type="email" required autocomplete="username"></label><label>Kata sandi<input name="password" type="password" required autocomplete="current-password" minlength="8"></label><button type="submit">Masuk</button></form><p id="message"></p><footer>Bagjasindo Mandiri Sindangkasih @gunzleite</footer></main>';document.getElementById('auth').onsubmit=async e=>{e.preventDefault();const fd=new FormData(e.target);const {error}=await db.auth.signInWithPassword({email:fd.get('email'),password:fd.get('password')});if(error)return msg(error.message);await start()};}
async function logout(){await db.auth.signOut();session=null;profile=null;login()}
let legacyDataLoaded=false;
let dashboardDataLoaded=false;
async function load(){
  legacyDataLoaded=false;
  dashboardDataLoaded=false;
  await render();
}
async function ensureDashboardData(force=false){
  if(dashboardDataLoaded&&!force)return;
  const [ar,b,cr,ci]=await Promise.all([
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,performance_template_name,start_date,active,created_at,ppl_id').order('created_at',{ascending:false}),
    db.from('barns').select('id,code,name'),
    db.from('contracts').select('id,number,doc_price,pre_starter_price,starter_price,finisher_price').is('cycle_id',null),
    db.from('chick_ins').select('id,contract_assignment_id,received,doa')
  ]);
  const err=[ar,b,cr,ci].find(x=>x.error)?.error;if(err)throw err;
  assignments=ar.data||[];barns=b.data||[];contracts=cr.data||[];
  window.__bmsDashboardChicks=ci.data||[];
  dashboardDataLoaded=true;
}
async function ensureLegacyData(){
  if(legacyDataLoaded)return;
  const [ar,b,i,su,e,a,p,k]=await Promise.all([
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active').order('created_at',{ascending:false}),
    db.from('barns').select('id,code,name'),
    db.from('items').select('id,code,name,supplier_id'),
    db.from('suppliers').select('id,code,name,active,supplier_type').order('code',{ascending:true}),
    db.from('employees').select('id,code,name,kind'),
    db.from('advance_balances').select('id,amount,balance'),
    db.from('profiles').select('user_id,full_name').eq('role','PPL').eq('active',true),
    db.from('contracts').select('id,number,cycle_id').is('cycle_id',null)
  ]);
  const err=[ar,b,i,su,e,a,p,k].find(x=>x.error)?.error;
  if(err)throw err;
  assignments=ar.data||[];barns=b.data||[];items=i.data||[];suppliers=su.data||[];employees=e.data||[];advances=a.data||[];pplUsers=p.data||[];contracts=k.data||[];contractReadiness=[];
  dashboardDataLoaded=true;
  legacyDataLoaded=true;
}

const NAV_SECTIONS=[
  {label:'Master Data',items:['kandang','item','supplier_sapronak','supplier_daging','kontrak','standar_performa','reset_klasemen','karyawan','pengguna','perusahaan']},
  {label:'Logistik',items:['logistik_kontrak','logistik_pengiriman','logistik_kiriman_luar','logistik_retur_luar','expedisi_usaha','logistik_laporan']},
  {label:'Produksi / PPL',items:['chick_in','recording','kunjungan','estimasi','liga_abk','rekap_produksi','ppl_rhpp_view','laporan']},
  {label:'Marketing',items:['marketing_panen_kontrak','marketing_tambah_daging','marketing_laporan']},
  {label:'Keuangan',items:['rhpp','rhpp_history','finance_rhpp_real','bop','bop_umum','bop_expedisi','gaji_abk','kasbon','cicilan','arus_kas','laporan_keuangan']},
  {label:'Owner',items:['owner_logistics_report','owner_marketing_report','owner_finance_report','owner_production_report','owner_ppl_report']}
];
const navLabel=(key)=>title[key];
const navButton=(key)=>{
  const allowed=canViewTab(key);
  const classes=[tab===key?'active':'',allowed?'':'nav-locked'].filter(Boolean).join(' ');
  return '<button data-tab="'+key+'" class="'+classes+'"'+(allowed?'':' disabled aria-disabled="true" title="Akses dikunci untuk akun ini"')+'>'+esc(navLabel(key)||key)+'</button>';
};
function appNav(){
  let html=navButton('dashboard');
  if(profile?.role==='ADMIN'){
    const adminRhppActive=['rhpp','rhpp_history','arsip_data'].includes(tab);
    html+='<details class="nav-group"'+(adminRhppActive?' open':'')+'><summary>Administrator</summary><div class="nav-sub">'+
      navButton('rhpp')+
      navButton('rhpp_history')+
      navButton('arsip_data')+
      '</div></details>';
  }
  for(const section of NAV_SECTIONS){
    const items=(profile?.role==='ADMIN'&&section.label==='Keuangan')
      ?section.items.filter(key=>key!=='rhpp'&&key!=='rhpp_history')
      :section.items;
    const logisticsNested=['logistik_retur','logistik_retur_luar'];
    const sectionActive=items.includes(tab)||(section.label==='Logistik'&&logisticsNested.includes(tab));
    const open=sectionActive?' open':'';
    const itemHtml=items.map(key=>{
      if(section.label==='Logistik'&&key==='logistik_pengiriman'){
        const shipOpen=(tab==='logistik_pengiriman'||tab==='logistik_retur')?' open':'';
        return '<details class="nav-subgroup"'+shipOpen+'><summary>Pengiriman</summary><div class="nav-child-item">'+
          navButton('logistik_pengiriman').replace('>'+esc(navLabel('logistik_pengiriman')||'logistik_pengiriman')+'<','>Sapronak<')+
          navButton('logistik_retur').replace('>'+esc(navLabel('logistik_retur')||'logistik_retur')+'<','>Retur<')+
          '</div></details>';
      }
      if(section.label==='Logistik'&&key==='logistik_kiriman_luar'){
        const extOpen=(tab==='logistik_kiriman_luar'||tab==='logistik_retur_luar')?' open':'';
        return '<details class="nav-subgroup"'+extOpen+'><summary>Sapronak Luar</summary><div class="nav-child-item">'+
          navButton('logistik_kiriman_luar').replace('>'+esc(navLabel('logistik_kiriman_luar')||'logistik_kiriman_luar')+'<','>Sapronak<')+
          navButton('logistik_retur_luar').replace('>'+esc(navLabel('logistik_retur_luar')||'logistik_retur_luar')+'<','>Retur<')+
          '</div></details>';
      }
      if(section.label==='Logistik'&&key==='logistik_retur_luar')return '';
      return navButton(key);
    }).join('');
    html+='<details class="nav-group"'+open+'><summary>'+esc(section.label)+'</summary><div class="nav-sub">'+itemHtml+'</div></details>';
  }
  html+=navButton('profil');
  return html;
}

function ownerReportPendingPage(){
  if(tab==='owner_logistics_report')return logisticsReports();
  if(tab==='owner_marketing_report')return marketingReports();
  if(tab==='owner_finance_report')return financeReportPage();
  if(tab==='owner_production_report')return reports();
  if(tab==='owner_ppl_report')return productionRecapPage();
  return;
}


const NAV_SVG={
  dashboard:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 11.5 12 4l9 7.5"/><path d="M5.5 10.5V20h13v-9.5"/><path d="M9.5 20v-5h5v5"/></svg>',
  grid:'<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="4" y="4" width="6" height="6" rx="1"/><rect x="14" y="4" width="6" height="6" rx="1"/><rect x="4" y="14" width="6" height="6" rx="1"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg>',
  truck:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 6h11v10H3z"/><path d="M14 9h4l3 3v4h-7z"/><circle cx="7" cy="18" r="2"/><circle cx="18" cy="18" r="2"/></svg>',
  production:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 19V8l4-3 4 3 3-2 3 2v11"/><path d="M8 19v-5h3v5"/><path d="M14 12h2M14 15h2"/></svg>',
  chart:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19V5"/><path d="M4 19h16"/><path d="m7 15 4-4 3 2 5-6"/></svg>',
  file:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h8l4 4v14H6z"/><path d="M14 3v5h5"/><path d="M9 13h6M9 17h6"/></svg>',
  wallet:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h15a2 2 0 0 1 2 2v9H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h12"/><path d="M16 11h5v4h-5a2 2 0 1 1 0-4Z"/></svg>',
  user:'<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="4"/><path d="M4.5 20c.7-4 3.2-6 7.5-6s6.8 2 7.5 6"/></svg>',
  box:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="m4 7 8-4 8 4-8 4z"/><path d="M4 7v10l8 4 8-4V7"/><path d="M12 11v10"/></svg>',
  clipboard:'<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="5" y="4" width="14" height="17" rx="2"/><path d="M9 4V2h6v2"/><path d="M8 9h8M8 13h8M8 17h5"/></svg>',
  users:'<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="9" cy="8" r="3"/><circle cx="17" cy="9" r="2"/><path d="M3 20c.5-4 2.5-6 6-6s5.5 2 6 6"/><path d="M14 15c3.4-.2 5.5 1.5 6 5"/></svg>',
  building:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 21V5l7-3 7 3v16"/><path d="M8 8h2M14 8h2M8 12h2M14 12h2M8 16h2M14 16h2"/></svg>',
  report:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 20V4h14v16z"/><path d="M8 15v2M12 11v6M16 7v10"/></svg>'
};
function navIconForTab(k){
  const map={
    dashboard:'dashboard',
    kandang:'building',item:'box',supplier_sapronak:'users',supplier_daging:'users',kontrak:'file',standar_performa:'chart',reset_klasemen:'chart',karyawan:'users',pengguna:'users',perusahaan:'building',
    logistik_kontrak:'file',logistik_pengiriman:'truck',logistik_kiriman_luar:'box',logistik_retur_luar:'box',logistik_retur:'truck',logistik_laporan:'report',
    chick_in:'production',recording:'clipboard',kunjungan:'clipboard',estimasi:'chart',liga_abk:'chart',rekap_produksi:'report',ppl_rhpp_view:'file',rhpp_history:'file',
    marketing_panen_kontrak:'chart',marketing_tambah_daging:'box',marketing_laporan:'report',
    rhpp:'file',arsip_data:'file',finance_rhpp_real:'file',bop:'wallet',bop_umum:'wallet',expedisi_usaha:'truck',bop_expedisi:'wallet',gaji_abk:'wallet',kasbon:'wallet',cicilan:'wallet',arus_kas:'chart',laporan_keuangan:'report',
    laporan:'report',profil:'user',harga_hidup:'chart',bonus_kontrak:'chart'
  };
  return NAV_SVG[map[k]||'grid'];
}
function navIconForGroup(label){
  const x=String(label||'').trim().toLowerCase();
  if(x.includes('master')||x.includes('referensi'))return NAV_SVG.grid;
  if(x.includes('logistik')||x.includes('sapronak'))return NAV_SVG.truck;
  if(x.includes('produksi'))return NAV_SVG.production;
  if(x.includes('marketing'))return NAV_SVG.chart;
  if(x.includes('keuangan')||x.includes('biaya')||x.includes('kasbon'))return NAV_SVG.wallet;
  return NAV_SVG.grid;
}
function decorateNavigation(rootEl){
  rootEl.querySelectorAll('#appSidebar nav button[data-tab]').forEach(btn=>{
    if(btn.querySelector('.nav-icon'))return;
    const icon=document.createElement('span');icon.className='nav-icon';icon.innerHTML=navIconForTab(btn.dataset.tab);
    const label=document.createElement('span');label.className='nav-label';label.textContent=btn.textContent.trim();
    btn.textContent='';btn.append(icon,label);
  });
  rootEl.querySelectorAll('#appSidebar summary').forEach(summary=>{
    if(summary.querySelector('.nav-icon'))return;
    const labelText=summary.textContent.trim();
    const icon=document.createElement('span');icon.className='nav-icon';icon.innerHTML=navIconForGroup(labelText);
    const label=document.createElement('span');label.className='nav-label';label.textContent=labelText;
    summary.textContent='';summary.append(icon,label);
  });
}
function layout(content){
  const navHtml=appNav();
  root.innerHTML=
    '<div class="mobile-topbar">'+
      '<button type="button" id="mobileMenuToggle" class="mobile-menu-toggle" aria-label="Buka menu" aria-expanded="false">☰</button>'+
      '<strong>BMS Mobile</strong>'+
      '<span>'+esc(profile.role)+'</span>'+
    '</div>'+
    '<div id="mobileNavBackdrop" class="mobile-nav-backdrop"></div>'+
    '<div class="shell">'+
      '<aside id="appSidebar">'+
        '<div class="mobile-drawer-head"><strong>BMS Mobile</strong><button type="button" id="mobileMenuClose" aria-label="Tutup menu">×</button></div>'+
        '<h1>BMS Mobile</h1><nav>'+navHtml+'</nav><footer>Bagjasindo Mandiri Sindangkasih @gunzleite</footer>'+
      '</aside>'+
      '<main><header><div><h2>'+title[tab]+'</h2><small>'+esc(profile.full_name)+' · '+esc(profile.role)+'</small></div></header><p id="message"></p>'+content+'</main>'+
    '</div>';
  decorateNavigation(root);
  if(navInitialCollapsePending){root.querySelectorAll('details.nav-group').forEach(d=>d.open=false);navInitialCollapsePending=false;}
  const sidebar=document.getElementById('appSidebar');
  const backdrop=document.getElementById('mobileNavBackdrop');
  const toggle=document.getElementById('mobileMenuToggle');
  const closeBtn=document.getElementById('mobileMenuClose');
  const setMenu=open=>{
    if(!sidebar||!backdrop)return;
    sidebar.classList.toggle('mobile-open',!!open);
    backdrop.classList.toggle('show',!!open);
    document.body.classList.toggle('mobile-menu-open',!!open);
    if(toggle)toggle.setAttribute('aria-expanded',open?'true':'false');
  };
  if(toggle)toggle.onclick=()=>setMenu(true);
  if(closeBtn)closeBtn.onclick=()=>setMenu(false);
  if(backdrop)backdrop.onclick=()=>setMenu(false);
  root.querySelectorAll('[data-tab]').forEach(b=>b.onclick=()=>{setMenu(false);tab=b.dataset.tab;render()});
  const mq=window.matchMedia('(min-width:901px)');
  const syncMenu=()=>{if(mq.matches)setMenu(false);};
  if(mq.addEventListener)mq.addEventListener('change',syncMenu);else if(mq.addListener)mq.addListener(syncMenu);
}

async function printFinanceDocument(sectionIds,heading){
  const ids=Array.isArray(sectionIds)?sectionIds:[sectionIds];
  const sections=ids.map(id=>document.getElementById(id)).filter(Boolean);
  if(!sections.length)return msg('Bagian yang akan dicetak belum tersedia.');
  const {data:company,error}=await db.from('company_profile').select('*').eq('id',true).maybeSingle();
  if(error)return msg(error.message);
  const cp=company||{};
  const body=sections.map(el=>{
    const clone=el.cloneNode(true);
    clone.querySelectorAll('button,form,.report-actions').forEach(x=>x.remove());
    return clone.innerHTML;
  }).join('<div class="print-gap"></div>');
  const w=window.open('','_blank');
  if(!w)return msg('Popup cetak diblokir browser.');
  const generated=new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',dateStyle:'long',timeStyle:'short'}).format(new Date());
  w.document.write('<html><head><meta charset="utf-8"><title>'+esc(heading||'Laporan')+'</title><style>'+
    '@page{size:A4;margin:12mm}body{font-family:Arial,sans-serif;color:#111;font-size:11px}'+
    '.print-head{border-bottom:2px solid #111;padding-bottom:8px;margin-bottom:14px}.print-head h2{margin:0 0 4px}.print-head div{margin:2px 0}'+
    'h3{margin:12px 0 7px}table{width:100%;border-collapse:collapse;margin:8px 0}th,td{border:1px solid #aaa;padding:5px;text-align:left;vertical-align:top}th{background:#eee}'+
    '.rhpp-summary-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:6px}.rhpp-summary-card{border:1px solid #bbb;padding:7px}.rhpp-summary-card span{display:block}.rhpp-summary-card strong{display:block;margin-top:3px}'+
    '.muted{color:#555}.print-gap{height:10px}.tablewrap{overflow:visible}.panel{border:0;padding:0;margin:0}'+
    '</style></head><body>'+
    '<div class="print-head">'+'<img src="'+BMS_PRINT_LOGO+'" style="max-height:42px;float:right;object-fit:contain">'+
    '<h2>'+esc(cp.company_name||cp.legal_name||'Bagjasindo Mandiri Sindangkasih')+'</h2>'+
    (cp.address?'<div>'+esc(cp.address)+'</div>':'')+
    (cp.phone?'<div>Tel/WA: '+esc(cp.phone)+'</div>':'')+
    (cp.email?'<div>Email: '+esc(cp.email)+'</div>':'')+
    '</div><h2>'+esc(heading||'Laporan')+'</h2><div style="margin-bottom:10px">Dicetak: '+esc(generated)+'</div>'+body+
    '</body></html>');
  w.document.close();
  setTimeout(()=>{w.focus();w.print();},400);
}

async function companyProfilePage(){
  const {data,error}=await db.from('company_profile').select('*').eq('id',true).maybeSingle();
  const x=data||{};
  let html='<section class="panel"><h3>Data Perusahaan</h3>'+
    '<p class="muted">Data ini menjadi kop resmi Cetak/PDF laporan.</p>'+
    '<form id="companyProfileForm" class="form-vertical">'+
      '<label>Logo Perusahaan<input type="file" id="companyLogoFile" accept="image/png,image/jpeg,image/webp"></label>'+
      '<div id="companyLogoPreview">'+(x.logo_url?'<img src="'+esc(x.logo_url)+'" alt="Logo Perusahaan" style="max-width:180px;max-height:120px;object-fit:contain;background:#fff;padding:8px;border-radius:8px">':'<p class="muted">Belum ada logo.</p>')+'</div>'+
      '<input type="hidden" name="logo_url" id="companyLogoData" value="'+esc(x.logo_url||'')+'">'+
      '<label>Nama Perusahaan<input name="company_name" value="'+esc(x.company_name||'')+'" required></label>'+
      '<label>Nama Legal<input name="legal_name" value="'+esc(x.legal_name||'')+'"></label>'+
      '<label>Alamat<textarea name="address" required>'+esc(x.address||'')+'</textarea></label>'+
      '<label>Telepon / WhatsApp<input name="phone" value="'+esc(x.phone||'')+'"></label>'+
      '<label>Email<input type="email" name="email" value="'+esc(x.email||'')+'"></label>'+
      '<label>Website<input name="website" value="'+esc(x.website||'')+'"></label>'+
      '<label>NPWP<input name="tax_number" value="'+esc(x.tax_number||'')+'"></label>'+
      '<label>Nomor Usaha<input name="business_id" value="'+esc(x.business_id||'')+'"></label>'+
      '<label>Penandatangan<input name="signatory_name" value="'+esc(x.signatory_name||'')+'"></label>'+
      '<label>Jabatan Penandatangan<input name="signatory_title" value="'+esc(x.signatory_title||'')+'"></label>'+
      '<button type="submit">Simpan Data Perusahaan</button>'+
    '</form></section>';
  layout(html);
  if(error)msg(error.message);
  const file=document.getElementById('companyLogoFile');
  const logoData=document.getElementById('companyLogoData');
  const preview=document.getElementById('companyLogoPreview');
  file.onchange=()=>{
    const picked=file.files&&file.files[0];
    if(!picked)return;
    if(!/^image\/(png|jpeg|webp)$/.test(picked.type))return msg('Logo harus PNG, JPG, atau WEBP.');
    if(picked.size>1024*1024)return msg('Ukuran logo maksimal 1 MB.');
    const reader=new FileReader();
    reader.onload=()=>{
      logoData.value=String(reader.result||'');
      preview.innerHTML='<img src="'+esc(logoData.value)+'" alt="Logo Perusahaan" style="max-width:180px;max-height:120px;object-fit:contain;background:#fff;padding:8px;border-radius:8px">';
    };
    reader.readAsDataURL(picked);
  };
  document.getElementById('companyProfileForm').onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(ev.currentTarget);
    const payload={
      id:true,
      logo_url:fd.get('logo_url')||null,
      company_name:fd.get('company_name'),
      legal_name:fd.get('legal_name')||null,
      address:fd.get('address'),
      phone:fd.get('phone')||null,
      email:fd.get('email')||null,
      website:fd.get('website')||null,
      tax_number:fd.get('tax_number')||null,
      business_id:fd.get('business_id')||null,
      signatory_name:fd.get('signatory_name')||null,
      signatory_title:fd.get('signatory_title')||null,
      updated_at:new Date().toISOString()
    };
    const {error}=await db.from('company_profile').upsert(payload);
    if(error)return msg(error.message);
    await companyProfilePage();
    msg('Data Perusahaan dan logo berhasil disimpan.',true);
  };
}

async function contractMasterPage(){
  const can=roles.kontrak.includes(profile.role);
  const [kr,pr,br]=await Promise.all([
    db.from('contracts').select('*').is('cycle_id',null).order('contract_date',{ascending:false,nullsFirst:false}).order('number',{ascending:true}),
    db.from('contract_live_prices').select('*').order('min_weight_kg',{ascending:true}),
    db.from('contract_bonuses').select('*').order('metric',{ascending:true}).order('min_value',{ascending:true})
  ]);

  const templates=kr.data||[];
  const selectedId=sessionStorage.getItem('bms_selected_contract_template');
  const selected=templates.find(x=>x.id===selectedId)||templates.find(x=>x.number==='MASTER-001')||templates[0]||null;
  const prices=selected?(pr.data||[]).filter(x=>x.contract_id===selected.id):[];
  const bonuses=selected?(br.data||[]).filter(x=>x.contract_id===selected.id):[];
  const ipRows=bonuses.filter(x=>x.metric==='IP');
  const fcrRows=bonuses.filter(x=>x.metric==='FCR_DIFFERENCE');
  const depletionRows=bonuses.filter(x=>x.metric==='DEPLETION');

  let html='<section class="panel"><h3>Master Kontrak</h3><p class="muted">Master kontrak dipilih saat Logistik membuat Kontrak Aktif per Kandang.</p>';

  if(can){
    html+='<form id="contractInfoForm" class="form-vertical">'+
      '<input type="hidden" name="id" value="'+(selected?esc(selected.id):'')+'">'+
      '<label>Nama Kontrak<input name="number" value="'+(selected?esc(selected.number):'')+'" placeholder="Contoh: Bounty September 2026" required></label>'+
      '<label>Tanggal Berlaku<input name="contract_date" type="date" value="'+(selected&&selected.contract_date?esc(selected.contract_date):'')+'"></label>'+
      '<label>Template Performa<select name="performance_template_name">'+
        '<option value="Performa Bounty" '+(selected?.performance_template_name==='Performa Bounty'?'selected':'')+'>Performa Bounty</option>'+
        '<option value="Performa BMS" '+(selected?.performance_template_name==='Performa BMS'?'selected':'')+'>Performa BMS</option>'+
      '</select></label>'+
      '<label>Keterangan<textarea name="signed_reference" placeholder="Keterangan kontrak">'+(selected?esc(selected.signed_reference||''):'')+'</textarea></label>'+
      '<div class="form-actions"><button type="submit">Simpan Kontrak</button><button type="button" id="newContractTemplate">Buat Kontrak Baru</button></div>'+
    '</form>';
  }
  html+='</section>';

  html+='<section class="panel"><h3>Harga Sapronak Kontrak</h3>';
  if(can&&selected){
    html+='<form id="sapronakContractPriceForm" class="form-vertical compact-form">'+
      '<label>DOC (Rp/ekor)<input name="doc_price" data-number="1" inputmode="decimal" value="'+fmtNumber(selected.doc_price||0)+'" required></label>'+
      '<label>Pre Starter (Rp/kg)<input name="pre_starter_price" data-number="1" inputmode="decimal" value="'+fmtNumber(selected.pre_starter_price||0)+'" required></label>'+
      '<label>Starter (Rp/kg)<input name="starter_price" data-number="1" inputmode="decimal" value="'+fmtNumber(selected.starter_price||0)+'" required></label>'+
      '<label>Finisher (Rp/kg)<input name="finisher_price" data-number="1" inputmode="decimal" value="'+fmtNumber(selected.finisher_price||0)+'" required></label>'+
      '<label>Dasar Harga OVK<select name="ovk_price_basis"><option value="FIXED" '+(selected.ovk_price_basis==='FIXED'?'selected':'')+'>Harga Tetap</option><option value="DISTRIBUTOR_PLUS_VAT" '+(selected.ovk_price_basis==='DISTRIBUTOR_PLUS_VAT'?'selected':'')+'>Distributor + PPN</option></select></label>'+
      '<label>Harga OVK Tetap / Satuan<input name="ovk_price" data-number="1" inputmode="decimal" value="'+fmtNumber(selected.ovk_price||0)+'"></label>'+
      '<label>PPN OVK (%)<input name="ovk_vat_percent" data-number="1" inputmode="decimal" value="'+(selected.ovk_vat_percent==null?'':fmtNumber(selected.ovk_vat_percent))+'"></label>'+
      '<button type="submit">Simpan Harga Sapronak</button>'+
    '</form>';
  }
  html+='</section>';

  html+='<section class="panel"><h3>Harga Ayam Hidup</h3>';
  if(can&&selected){
    html+='<form id="priceRowForm" class="form-vertical compact-form">'+
      '<input type="hidden" name="id">'+
      '<label>Bobot Minimum (kg)<input name="min_weight_kg" data-number="1" inputmode="decimal" required></label>'+
      '<label>Bobot Maksimum (kg)<input name="max_weight_kg" data-number="1" inputmode="decimal" placeholder="Kosong = tanpa batas atas"></label>'+
      '<label>Harga (Rp/kg)<input name="price_per_kg" data-number="1" inputmode="decimal" required></label>'+
      '<button type="submit">Simpan Baris Harga</button>'+
    '</form>';
  }
  html+='<div class="tablewrap"><table><thead><tr><th>Bobot Min</th><th>Bobot Max</th><th>Harga/kg</th>'+(can?'<th>Aksi</th>':'')+'</tr></thead><tbody>'+
    prices.map(x=>'<tr><td>'+fmtNumber(x.min_weight_kg)+'</td><td>'+(x.max_weight_kg==null?'Tanpa batas':fmtNumber(x.max_weight_kg))+'</td><td>Rp '+fmtNumber(x.price_per_kg)+'</td>'+(can?'<td><button type="button" data-edit-price="'+esc(x.id)+'">Edit</button></td>':'')+'</tr>').join('')+
    '</tbody></table></div></section>';

  html+='<section class="panel"><h3>Bonus IP</h3>';
  if(can&&selected){
    html+='<form id="ipRowForm" class="form-vertical compact-form">'+
      '<input type="hidden" name="id">'+
      '<label>IP Minimum<input name="min_value" data-number="1" inputmode="decimal"></label>'+
      '<label>IP Maksimum<input name="max_value" data-number="1" inputmode="decimal"></label>'+
      '<label>Bonus (Rp/kg)<input name="rupiah_per_kg" data-number="1" inputmode="decimal" required></label>'+
      '<label>Keterangan<input name="notes"></label>'+
      '<button type="submit">Simpan Bonus IP</button>'+
    '</form>';
  }
  html+='<div class="tablewrap"><table><thead><tr><th>Min</th><th>Max</th><th>Bonus/kg</th><th>Keterangan</th>'+(can?'<th>Aksi</th>':'')+'</tr></thead><tbody>'+
    ipRows.map(x=>'<tr><td>'+(x.min_value==null?'-':fmtNumber(x.min_value))+'</td><td>'+(x.max_value==null?'-':fmtNumber(x.max_value))+'</td><td>Rp '+fmtNumber(x.rupiah_per_kg)+'</td><td>'+esc(x.notes||'')+'</td>'+(can?'<td><button type="button" data-edit-ip="'+esc(x.id)+'">Edit</button></td>':'')+'</tr>').join('')+
    '</tbody></table></div></section>';

  html+='<section class="panel"><h3>Bonus FCR</h3>';
  if(can&&selected){
    html+='<form id="fcrRowForm" class="form-vertical compact-form">'+
      '<input type="hidden" name="id">'+
      '<label>Selisih FCR Minimum<input name="min_value" data-number="1" inputmode="decimal"></label>'+
      '<label>Selisih FCR Maksimum<input name="max_value" data-number="1" inputmode="decimal"></label>'+
      '<label>Bonus (Rp/kg)<input name="rupiah_per_kg" data-number="1" inputmode="decimal" required></label>'+
      '<label>Keterangan<input name="notes"></label>'+
      '<button type="submit">Simpan Bonus FCR</button>'+
    '</form>';
  }
  html+='<div class="tablewrap"><table><thead><tr><th>Min</th><th>Max</th><th>Bonus/kg</th><th>Keterangan</th>'+(can?'<th>Aksi</th>':'')+'</tr></thead><tbody>'+
    fcrRows.map(x=>'<tr><td>'+(x.min_value==null?'-':fmtNumber(x.min_value))+'</td><td>'+(x.max_value==null?'-':fmtNumber(x.max_value))+'</td><td>Rp '+fmtNumber(x.rupiah_per_kg)+'</td><td>'+esc(x.notes||'')+'</td>'+(can?'<td><button type="button" data-edit-fcr="'+esc(x.id)+'">Edit</button></td>':'')+'</tr>').join('')+
    '</tbody></table></div></section>';

  html+='<section class="panel"><h3>Bonus Deplesi</h3>';
  if(can&&selected){
    html+='<form id="depletionRowForm" class="form-vertical compact-form">'+
      '<input type="hidden" name="id">'+
      '<label>Deplesi Minimum (%)<input name="min_value" data-number="1" inputmode="decimal"></label>'+
      '<label>Deplesi Maksimum (%)<input name="max_value" data-number="1" inputmode="decimal"></label>'+
      '<label>Bonus (Rp/kg)<input name="rupiah_per_kg" data-number="1" inputmode="decimal" required></label>'+
      '<label>Keterangan<input name="notes"></label>'+
      '<button type="submit">Simpan Bonus Deplesi</button>'+
    '</form>';
  }
  html+='<div class="tablewrap"><table><thead><tr><th>Min %</th><th>Max %</th><th>Bonus/kg</th><th>Keterangan</th>'+(can?'<th>Aksi</th>':'')+'</tr></thead><tbody>'+
    depletionRows.map(x=>'<tr><td>'+(x.min_value==null?'-':fmtNumber(x.min_value))+'</td><td>'+(x.max_value==null?'-':fmtNumber(x.max_value))+'</td><td>Rp '+fmtNumber(x.rupiah_per_kg)+'</td><td>'+esc(x.notes||'')+'</td>'+(can?'<td><button type="button" data-edit-depletion="'+esc(x.id)+'">Edit</button></td>':'')+'</tr>').join('')+
    '</tbody></table></div></section>';

  html+='<section class="panel"><h3>Template Kontrak</h3><p class="muted">Penggunaan kontrak dilakukan dari menu Logistik → Buat Kontrak.</p>';
  html+='<div class="tablewrap"><table id="contractTemplateTable"><thead><tr><th>Nama Kontrak</th><th>Tanggal Berlaku</th><th>Performa</th><th>Harga</th><th>Bonus IP</th><th>Bonus FCR / Deplesi</th><th>Aksi</th></tr></thead><tbody>'+
    templates.map(t=>{
      const tPrices=(pr.data||[]).filter(x=>x.contract_id===t.id);
      const tBonuses=(br.data||[]).filter(x=>x.contract_id===t.id);
      const tip=tBonuses.filter(x=>x.metric==='IP');
      const tfcr=tBonuses.filter(x=>x.metric==='FCR_DIFFERENCE');
      const tdep=tBonuses.filter(x=>x.metric==='DEPLETION');
      return '<tr><td>'+esc(t.number)+'</td><td>'+esc(t.contract_date||'-')+'</td><td>'+esc(t.performance_template_name||'-')+'</td><td>'+tPrices.length+' baris</td><td>'+tip.length+' baris</td><td>'+tfcr.length+' baris / Deplesi '+tdep.length+'</td><td>'+
        '<button type="button" data-contract-view="'+esc(t.id)+'">Lihat</button> '+
        (can?'<button type="button" data-contract-edit="'+esc(t.id)+'">Edit</button> ':'')+

      '</td></tr>';
    }).join('')+
    '</tbody></table></div></section>';

  layout(html);
  bindNumberInputs();
  attachListFilter({tableId:'contractTemplateTable',fields:[
    {label:'Nama Kontrak',col:0,placeholder:'Nama kontrak'},
    {label:'Tanggal Berlaku',col:1,placeholder:'YYYY-MM-DD'},
    {label:'Performa',col:2,placeholder:'Template performa'}
  ]});

  if(!can)return;

  const cf=document.getElementById('contractInfoForm');
  document.getElementById('newContractTemplate').onclick=()=>{
    cf.reset();
    cf.elements.id.value='';
    cf.elements.performance_template_name.value='Performa Bounty';
    msg('Form kontrak baru siap diisi.',true);
  };

  cf.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(cf);
    const id=fd.get('id');
    const o={
      number:fd.get('number'),
      contract_date:fd.get('contract_date')||null,
      performance_template_name:fd.get('performance_template_name'),
      signed_reference:fd.get('signed_reference')||null
    };
    let result;
    if(id) result=await db.from('contracts').update(o).eq('id',id);
    else result=await db.from('contracts').insert({
      ...o,doc_price:0,pre_starter_price:0,starter_price:0,finisher_price:0,
      ovk_price:0,harvest_price:0,ovk_price_basis:'FIXED'
    }).select('id').single();
    if(result.error)return msg(result.error.message);
    if(result.data?.id)sessionStorage.setItem('bms_selected_contract_template',result.data.id);
    await load();msg('Kontrak tersimpan.',true);
  };

  const sapronakContractPriceForm=document.getElementById('sapronakContractPriceForm');
  if(sapronakContractPriceForm){
    sapronakContractPriceForm.onsubmit=async ev=>{
      ev.preventDefault();
      const fd=new FormData(ev.currentTarget);
      const payload={
        doc_price:normalizeInputID(fd.get('doc_price'))||0,
        pre_starter_price:normalizeInputID(fd.get('pre_starter_price'))||0,
        starter_price:normalizeInputID(fd.get('starter_price'))||0,
        finisher_price:normalizeInputID(fd.get('finisher_price'))||0,
        ovk_price_basis:fd.get('ovk_price_basis')||'FIXED',
        ovk_price:normalizeInputID(fd.get('ovk_price'))||0,
        ovk_vat_percent:normalizeInputID(fd.get('ovk_vat_percent'))
      };
      const {error}=await db.from('contracts').update(payload).eq('id',selected.id);
      if(error)return msg(error.message);
      await contractMasterPage();msg('Harga Sapronak kontrak diperbarui.',true);
    };
  }

  const priceForm=document.getElementById('priceRowForm');
  if(priceForm){
    root.querySelectorAll('[data-edit-price]').forEach(btn=>btn.onclick=()=>{
      const x=prices.find(v=>v.id===btn.dataset.editPrice);if(!x)return;
      priceForm.elements.id.value=x.id;
      priceForm.elements.min_weight_kg.value=fmtNumber(x.min_weight_kg);
      priceForm.elements.max_weight_kg.value=x.max_weight_kg==null?'':fmtNumber(x.max_weight_kg);
      priceForm.elements.price_per_kg.value=fmtNumber(x.price_per_kg);
      priceForm.scrollIntoView({behavior:'smooth',block:'start'});
    });
    priceForm.onsubmit=async ev=>{
      ev.preventDefault();
      const fd=new FormData(priceForm),id=fd.get('id');
      const o={contract_id:selected.id,min_weight_kg:normalizeInputID(fd.get('min_weight_kg')),max_weight_kg:normalizeInputID(fd.get('max_weight_kg')),price_per_kg:normalizeInputID(fd.get('price_per_kg'))};
      const q=id?db.from('contract_live_prices').update(o).eq('id',id):db.from('contract_live_prices').insert(o);
      const {error}=await q;if(error)return msg(error.message);
      await contractMasterPage();msg('Harga ayam hidup tersimpan.',true);
    };
  }

  const setupBonus=(formId,metric,buttonAttr,rows)=>{
    const form=document.getElementById(formId);if(!form)return;
    root.querySelectorAll('['+buttonAttr+']').forEach(btn=>btn.onclick=()=>{
      const x=rows.find(v=>v.id===btn.getAttribute(buttonAttr));if(!x)return;
      form.elements.id.value=x.id;
      form.elements.min_value.value=x.min_value==null?'':fmtNumber(x.min_value);
      form.elements.max_value.value=x.max_value==null?'':fmtNumber(x.max_value);
      form.elements.rupiah_per_kg.value=fmtNumber(x.rupiah_per_kg);
      form.elements.notes.value=x.notes||'';
      form.scrollIntoView({behavior:'smooth',block:'start'});
    });
    form.onsubmit=async ev=>{
      ev.preventDefault();const fd=new FormData(form),id=fd.get('id');
      const o={contract_id:selected.id,metric,min_value:normalizeInputID(fd.get('min_value')),max_value:normalizeInputID(fd.get('max_value')),rupiah_per_kg:normalizeInputID(fd.get('rupiah_per_kg')),notes:fd.get('notes')||null};
      const q=id?db.from('contract_bonuses').update(o).eq('id',id):db.from('contract_bonuses').insert(o);
      const {error}=await q;if(error)return msg(error.message);
      await contractMasterPage();msg(metric==='IP'?'Bonus IP tersimpan.':metric==='DEPLETION'?'Bonus Deplesi tersimpan.':'Bonus FCR tersimpan.',true);
    };
  };

  setupBonus('ipRowForm','IP','data-edit-ip',ipRows);
  setupBonus('fcrRowForm','FCR_DIFFERENCE','data-edit-fcr',fcrRows);
  setupBonus('depletionRowForm','DEPLETION','data-edit-depletion',depletionRows);

  root.querySelectorAll('[data-contract-view]').forEach(btn=>btn.onclick=()=>{
    sessionStorage.setItem('bms_selected_contract_template',btn.dataset.contractView);
    contractMasterPage();
  });

  root.querySelectorAll('[data-contract-edit]').forEach(btn=>btn.onclick=()=>{
    sessionStorage.setItem('bms_selected_contract_template',btn.dataset.contractEdit);
    contractMasterPage();
  });

}

async function performanceMasterPage(){
  const can=roles.standar_performa.includes(profile.role);
  const kr=await db.from('contracts').select('id,number').order('number',{ascending:true});
  const master=(kr.data||[]).find(x=>x.number==='MASTER-001')||(kr.data||[])[0];
  if(!master)return layout('<section class="panel"><p>Master Kontrak belum tersedia.</p></section>');

  const rr=await db.from('performance_standards').select('*').eq('contract_id',master.id).order('template_name',{ascending:true}).order('age_days',{ascending:true});
  const all=rr.data||[];
  const templates=[...new Set(all.map(x=>x.template_name).filter(Boolean))];
  const selected=sessionStorage.getItem('bms_perf_template')||templates[0]||'';
  const rows=all.filter(x=>x.template_name===selected);

  let html='<section class="panel"><h3>Master Performa</h3>'+
    '<label>Pilih Template Performa<select id="perfTemplateSelect">'+
      templates.map(name=>'<option value="'+esc(name)+'" '+(name===selected?'selected':'')+'>'+esc(name)+'</option>').join('')+
    '</select></label>'+
    '<p class="muted">Pilih satu template. Data template yang dipilih tampil di bawah.</p>';

  if(can&&selected){
    html+='<form id="perfEdit" class="form-vertical">'+
      '<input type="hidden" name="id">'+
      '<label>Umur (hari)<input name="age_days" data-number="1" inputmode="numeric" required></label>'+
      '<label>Standar Pakan (g/ekor)<input name="std_feed_g_per_bird" data-number="1" inputmode="decimal"></label>'+
      '<label>Standar BW (g)<input name="std_body_weight_g" data-number="1" inputmode="decimal"></label>'+
      '<label>Standar FCR<input name="std_fcr" data-number="1" inputmode="decimal"></label>'+
      '<button type="submit">Simpan Perubahan</button>'+
    '</form>';
  }

  html+='<div class="tablewrap"><table id="performanceMasterTable"><thead><tr><th>Umur</th><th>Std Pakan g/ekor</th><th>Std BW g</th><th>Std FCR</th>'+(can?'<th>Aksi</th>':'')+'</tr></thead><tbody>'+
    rows.map(x=>'<tr><td>'+fmtNumber(x.age_days)+'</td><td>'+(x.std_feed_g_per_bird==null?'-':fmtNumber(x.std_feed_g_per_bird))+'</td><td>'+(x.std_body_weight_g==null?'-':fmtNumber(x.std_body_weight_g))+'</td><td>'+(x.std_fcr==null?'-':fmtNumber(x.std_fcr))+'</td>'+(can?'<td><button type="button" data-edit-perf="'+esc(x.id)+'">Edit</button></td>':'')+'</tr>').join('')+
    '</tbody></table></div></section>';

  layout(html);
  bindNumberInputs();
  attachListFilter({tableId:'performanceMasterTable',fields:[
    {label:'Umur',col:0,placeholder:'Umur hari'},
    {label:'Std Pakan',col:1,placeholder:'Standar pakan'},
    {label:'Std BW',col:2,placeholder:'Standar BW'},
    {label:'Std FCR',col:3,placeholder:'Standar FCR'}
  ]});

  const sel=document.getElementById('perfTemplateSelect');
  if(sel)sel.onchange=()=>{
    sessionStorage.setItem('bms_perf_template',sel.value);
    performanceMasterPage();
  };

  if(!can||!selected)return;
  const pf=document.getElementById('perfEdit');
  root.querySelectorAll('[data-edit-perf]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.id===btn.dataset.editPerf);if(!x)return;
    pf.elements.id.value=x.id;
    pf.elements.age_days.value=fmtNumber(x.age_days);
    pf.elements.std_feed_g_per_bird.value=x.std_feed_g_per_bird==null?'':fmtNumber(x.std_feed_g_per_bird);
    pf.elements.std_body_weight_g.value=x.std_body_weight_g==null?'':fmtNumber(x.std_body_weight_g);
    pf.elements.std_fcr.value=x.std_fcr==null?'':fmtNumber(x.std_fcr);
    pf.scrollIntoView({behavior:'smooth',block:'start'});
  });
  pf.onsubmit=async ev=>{
    ev.preventDefault();const fd=new FormData(pf),id=fd.get('id');
    const o={
      contract_id:master.id,
      template_name:selected,
      age_days:normalizeInputID(fd.get('age_days')),
      std_feed_g_per_bird:normalizeInputID(fd.get('std_feed_g_per_bird')),
      std_body_weight_g:normalizeInputID(fd.get('std_body_weight_g')),
      std_fcr:normalizeInputID(fd.get('std_fcr'))
    };
    const q=id?db.from('performance_standards').update(o).eq('id',id):db.from('performance_standards').insert(o);
    const {error}=await q;if(error)return msg(error.message);
    await performanceMasterPage();msg('Template performa diperbarui.',true);
  };
}

function profilePage(){
  const email=session?.user?.email||'-';
  layout(
    '<section class="panel"><h3>Profil</h3>'+
    '<p><strong>Nama</strong><br>'+esc(profile.full_name||'-')+'</p>'+
    '<p><strong>Role</strong><br>'+esc(profile.role||'-')+'</p>'+
    '<p><strong>Email</strong><br>'+esc(email)+'</p>'+
    '</section>'+
    '<section class="panel"><h3>Ubah Password</h3>'+
    '<form id="profilePasswordForm" class="form-vertical">'+
      '<label>Password Baru<div class="password-wrap"><input id="profilePassword1" name="password" type="password" autocomplete="new-password" required><button type="button" data-toggle-password="profilePassword1">Lihat</button></div></label>'+
      '<label>Konfirmasi Password Baru<div class="password-wrap"><input id="profilePassword2" name="confirm_password" type="password" autocomplete="new-password" required><button type="button" data-toggle-password="profilePassword2">Lihat</button></div></label>'+
      '<button type="submit">Simpan Password</button>'+
    '</form>'+
    '</section>'+
    '<section class="panel"><button id="profileLogout">Keluar</button></section>'
  );

  document.querySelectorAll('[data-toggle-password]').forEach(btn=>btn.onclick=()=>{
    const input=document.getElementById(btn.dataset.togglePassword);
    if(!input)return;
    const show=input.type==='password';
    input.type=show?'text':'password';
    btn.textContent=show?'Tutup':'Lihat';
  });

  document.getElementById('profilePasswordForm').onsubmit=async ev=>{
    ev.preventDefault();
    const f=ev.currentTarget;
    const p1=f.elements.password.value;
    const p2=f.elements.confirm_password.value;
    if(p1!==p2)return msg('Konfirmasi password tidak sama.');
    const {error}=await db.auth.updateUser({password:p1});
    if(error)return msg(error.message);
    f.reset();
    document.querySelectorAll('[data-toggle-password]').forEach(btn=>{
      const input=document.getElementById(btn.dataset.togglePassword);
      if(input)input.type='password';
      btn.textContent='Lihat';
    });
    msg('Password berhasil diperbarui.',true);
  };

  document.getElementById('profileLogout').onclick=logout;
}
function field([key,label,type]){let options=type==='assignment'?assignments.filter(a=>a.active).map(a=>[a.id,assignmentActiveBarnLabel(barns,a)]):type==='barn'?barns.map(b=>[b.id,shortBarnLabel(b)]):type==='item'?items.map(i=>[i.id,i.code+' · '+i.name]):type==='supplier'?suppliers.filter(s=>s.active&&s.supplier_type==='SAPRONAK').map(s=>[s.id,s.code+' · '+s.name]):type==='contract'?contracts.map(k=>[k.id,k.number]):type==='employee'?employees.map(e=>[e.id,e.code+' · '+e.name]):type==='abk'?employees.filter(e=>e.kind==='ABK').map(e=>[e.id,e.code+' · '+e.name]):type==='ppl'?pplUsers.map(p=>[p.user_id,p.full_name]):type==='advance'?advances.filter(a=>a.balance>0).map(a=>[a.id,'Sisa Rp '+a.balance]):null;const required=new Set(['contract_assignment_id','contract_id','barn_id','employee_id','advance_id','code','name','unit','capacity','kind','initial_population','company_name','number','contract_date','integrator','arrived_on','shipped','received','doa','item_id','quantity','received_on','recorded_on','age_days','visited_on','harvested_on','transaction_number','birds','net_weight_kg','price_per_kg','incurred_on','category','amount','advanced_on','paid_on','method','departed_on','destination','estimated_on','min_weight_kg','price_per_kg','metric','rupiah_per_kg','std_body_weight_g','std_fcr','std_feed_g_per_bird']);let input=type==='computed'?'<input type="text" data-computed="'+key+'" readonly tabindex="-1">':options?'<select name="'+key+'" '+(required.has(key)?'required':'')+'><option value="">Pilih '+label+'</option>'+options.map(([v,t])=>'<option value="'+esc(v)+'">'+esc(t)+'</option>').join('')+'</select>':type?.startsWith('select:')?'<select name="'+key+'">'+type.slice(7).split(',').map(v=>'<option>'+esc(v)+'</option>').join('')+'</select>':'<input name="'+key+'" type="'+(type==='number'?'text':(type||'text'))+'" '+(type==='number'?'data-number="1" inputmode="decimal" autocomplete="off"':'')+(required.has(key)?' required':'')+'>';return '<label>'+label+input+'</label>'}
async function logisticsContractPage(){
  const [br,cr,pr,ar,er,abr,ppr]=await Promise.all([
    db.from('barns').select('id,code,name,location,kind,active').eq('active',true).order('code',{ascending:true}),
    db.from('contracts').select('id,number,contract_date,performance_template_name').is('cycle_id',null).order('contract_date',{ascending:false,nullsFirst:false}).order('number',{ascending:true}),
    db.from('performance_standards').select('contract_id,template_name').order('template_name',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,performance_template_name,start_date,active,created_at,ppl_id').order('created_at',{ascending:false}),
    db.from('employees').select('id,code,name,kind,active').eq('kind','ABK').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_contract_assignment_abks').select('id,contract_assignment_id,abk_id,initial_birds,feed_pre_bags,feed_starter_bags,feed_finisher_bags,basics_locked_at,created_at').order('created_at',{ascending:true}),
    db.from('profiles').select('user_id,full_name,role,active').eq('role','PPL').eq('active',true).order('full_name',{ascending:true})
  ]);

  const barns=br.data||[];
  const masters=cr.data||[];
  const perfRows=pr.data||[];
  const allAssignments=ar.data||[];
  const activeAssignments=allAssignments.filter(x=>x.active);
  const abks=er.data||[];
  const abkLinks=abr.data||[];
  const ppls=ppr.data||[];
  const pplName=id=>ppls.find(x=>x.user_id===id)?.full_name||'-';
  const lockedBarnIds=new Set(activeAssignments.map(x=>x.barn_id));
  const availableBarns=barns.filter(x=>!lockedBarnIds.has(x.id));
  const abkName=id=>{const x=abks.find(a=>a.id===id);return x?x.code+' · '+x.name:'-'};
  const linksFor=id=>abkLinks.filter(x=>x.contract_assignment_id===id);

  let html='<section class="panel"><h3>Buat Kontrak</h3>'+
    '<form id="logisticsContractForm" class="form-vertical">'+
      '<label>Cari / Pilih Kandang<input id="contractBarnSearch" autocomplete="off" placeholder="Contoh: cicurug" required></label>'+
      '<input type="hidden" name="barn_id" id="contractBarnId">'+
      '<div id="contractBarnSuggestions" class="search-suggestions"></div>'+
      '<label>Pilih Kontrak<select name="master_contract_id" id="logisticsMasterContract" required><option value="">Pilih Kontrak</option>'+
        masters.map(x=>'<option value="'+esc(x.id)+'">'+esc(x.number)+(x.contract_date?' · '+esc(x.contract_date):'')+'</option>').join('')+
      '</select></label>'+
      '<label>Pilih Performa<select name="performance_template_name" id="logisticsPerformance" required><option value="">Pilih Performa</option></select></label>'+
      '<label>Tanggal Mulai<input type="date" name="start_date" id="logisticsStartDate" required></label>'+ 
      '<label>Pilih PPL<select name="ppl_id" id="logisticsPpl" required><option value="">Pilih PPL</option>'+ppls.map(x=>'<option value="'+esc(x.user_id)+'">'+esc(x.full_name)+'</option>').join('')+'</select></label>'+
      '<section class="panel" style="margin:0"><h4>ABK Kandang</h4><div id="contractAbkRows"></div><button type="button" id="addContractAbk">+ Tambah ABK</button></section>'+
      '<button type="submit">Simpan</button>'+
    '</form>'+
    (!availableBarns.length?'<p class="muted">Semua kandang sedang memiliki kontrak aktif.</p>':'')+
    '</section>';

  html+='<section class="panel"><h3>Kontrak Aktif per Kandang</h3><div class="tablewrap"><table><thead><tr><th>Kandang</th><th>Siklus</th><th>Kontrak</th><th>Performa</th><th>PPL</th><th>ABK</th><th>Tanggal Mulai</th><th>Status</th><th>Aksi</th></tr></thead><tbody>'+
    activeAssignments.map(a=>{
      const b=barns.find(x=>x.id===a.barn_id);
      const k=masters.find(x=>x.id===a.master_contract_id);
      const ls=linksFor(a.id);
      return '<tr><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td><strong>'+esc(assignmentCycleLabel(allAssignments,a))+'</strong></td><td>'+esc(shortContractLabel(k?.number)||'-')+'</td><td>'+esc(a.performance_template_name||'-')+'</td><td>'+esc(pplName(a.ppl_id))+'</td><td>'+ls.length+' ABK</td><td>'+esc(a.start_date||'-')+'</td><td><span class="pill">AKTIF</span></td><td><button type="button" class="btn-secondary" data-contract-detail="'+esc(a.id)+'">Detail</button></td></tr>';
    }).join('')+
    '</tbody></table></div>'+(!activeAssignments.length?'<p>Belum ada kontrak kandang aktif.</p>':'')+'</section>'+
    '<section class="panel" id="contractActiveDetail" hidden><h3>Detail Kontrak Aktif</h3><div id="contractActiveDetailBody"></div></section>';

  layout(html);
  bindNumberInputs();
  if(br.error||cr.error||pr.error||ar.error||er.error||abr.error||ppr.error)msg((br.error||cr.error||pr.error||ar.error||er.error||abr.error||ppr.error).message);

  const contractSelect=document.getElementById('logisticsMasterContract');
  const perfSelect=document.getElementById('logisticsPerformance');
  const startDateInput=document.getElementById('logisticsStartDate');
  if(startDateInput&&!startDateInput.value){
    startDateInput.value=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());
  }
  const barnSearch=document.getElementById('contractBarnSearch');
  const barnIdInput=document.getElementById('contractBarnId');
  const barnSuggestions=document.getElementById('contractBarnSuggestions');
  const abkRows=document.getElementById('contractAbkRows');

  const selectedAbks=[{id:'',initial_birds:0}];
  const syncContractAbkRows=()=>{
    abkRows.querySelectorAll('[data-contract-abk-index]').forEach(sel=>{const i=Number(sel.dataset.contractAbkIndex);if(selectedAbks[i])selectedAbks[i].id=sel.value});
    abkRows.querySelectorAll('[data-contract-abk-pop]').forEach(inp=>{const i=Number(inp.dataset.contractAbkPop);if(selectedAbks[i])selectedAbks[i].initial_birds=Math.trunc(normalizeInputID(inp.value)||0)});
  };
  const renderAbkRows=()=>{
    abkRows.innerHTML=selectedAbks.map((row,idx)=>{
      const used=new Set(selectedAbks.filter((v,i)=>v.id&&i!==idx).map(v=>v.id));
      return '<div class="form-vertical compact-form" style="margin-bottom:10px"><label>ABK<select data-contract-abk-index="'+idx+'" required><option value="">Pilih ABK</option>'+
        abks.filter(x=>!used.has(x.id)||x.id===row.id).map(x=>'<option value="'+esc(x.id)+'" '+(x.id===row.id?'selected':'')+'>'+esc(x.code+' · '+x.name)+'</option>').join('')+
        '</select></label><label>Populasi Awal ABK (ekor)<input type="text" data-number="1" inputmode="decimal" data-contract-abk-pop="'+idx+'" value="'+(row.initial_birds?fmtNumber(row.initial_birds):'')+'" placeholder="Contoh: 8.250" required></label>'+
        (selectedAbks.length>1?'<button type="button" data-remove-contract-abk="'+idx+'">Hapus ABK</button>':'')+'</div>';
    }).join('');
    bindNumberInputs();
    abkRows.querySelectorAll('[data-contract-abk-index]').forEach(sel=>sel.onchange=()=>{syncContractAbkRows();renderAbkRows()});
    abkRows.querySelectorAll('[data-remove-contract-abk]').forEach(btn=>btn.onclick=()=>{syncContractAbkRows();selectedAbks.splice(Number(btn.dataset.removeContractAbk),1);renderAbkRows()});
  };
  document.getElementById('addContractAbk').onclick=()=>{
    syncContractAbkRows();
    const chosen=selectedAbks.filter(x=>x.id);
    if(chosen.length>=abks.length)return msg('Semua ABK aktif sudah dipilih.');
    selectedAbks.push({id:'',initial_birds:0});
    renderAbkRows();
  };
  renderAbkRows();

  const refreshPerformance=()=>{
    const contractId=contractSelect.value;
    const names=[...new Set(perfRows.filter(x=>x.contract_id===contractId).map(x=>x.template_name).filter(Boolean))];
    perfSelect.innerHTML='<option value="">Pilih Performa</option>'+
      names.map(name=>'<option value="'+esc(name)+'">'+esc(name)+'</option>').join('');
  };

  const renderBarnSuggestions=()=>{
    const q=(barnSearch.value||'').trim().toLowerCase();
    barnIdInput.value='';
    const rows=q?availableBarns.filter(x=>[x.code,x.name,x.location,x.kind].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5):[];
    barnSuggestions.innerHTML=rows.map(x=>'<button type="button" class="search-suggestion" data-barn-id="'+esc(x.id)+'"><strong>'+esc(x.code+' · '+x.name)+'</strong><br><small>'+esc([x.location,x.kind].filter(Boolean).join(' · '))+'</small></button>').join('');
    if(q&&!rows.length)barnSuggestions.innerHTML='<div class="search-empty">Kandang tidak ditemukan.</div>';
    barnSuggestions.querySelectorAll('[data-barn-id]').forEach(btn=>btn.onclick=()=>{
      const b=availableBarns.find(x=>x.id===btn.dataset.barnId);
      if(!b)return;
      barnSearch.value=shortBarnLabel(b);
      barnIdInput.value=b.id;
      barnSuggestions.innerHTML='';
    });
  };

  contractSelect.onchange=refreshPerformance;
  barnSearch.oninput=renderBarnSuggestions;
  barnSearch.onfocus=renderBarnSuggestions;
  refreshPerformance();

  document.getElementById('logisticsContractForm').onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(ev.currentTarget);
    if(!fd.get('barn_id'))return msg('Kandang wajib dipilih.');
    syncContractAbkRows();
    const chosenAbks=selectedAbks.filter(x=>x.id);
    if(!chosenAbks.length)return msg('Pilih minimal 1 ABK untuk kandang ini.');
    if(chosenAbks.some(x=>!Number.isInteger(x.initial_birds)||x.initial_birds<=0))return msg('Populasi Awal setiap ABK wajib diisi.');
    const payload={
      barn_id:fd.get('barn_id'),
      master_contract_id:fd.get('master_contract_id'),
      performance_template_name:fd.get('performance_template_name'),
      start_date:fd.get('start_date'),
      ppl_id:fd.get('ppl_id')
    };
    const {data:created,error}=await db.from('logistics_contract_assignments').insert(payload).select('id').single();
    if(error)return msg(error.message);
    const {error:abkError}=await db.from('logistics_contract_assignment_abks').insert(chosenAbks.map(x=>({contract_assignment_id:created.id,abk_id:x.id,initial_birds:x.initial_birds})));
    if(abkError){
      await db.from('logistics_contract_assignments').delete().eq('id',created.id);
      return msg(abkError.message);
    }
    await logisticsContractPage();
    msg('Kontrak kandang dan ABK berhasil disimpan.',true);
  };

  const detailPanel=document.getElementById('contractActiveDetail');
  const detailBody=document.getElementById('contractActiveDetailBody');
  const renderContractDetail=id=>{
    const a=activeAssignments.find(x=>x.id===id);if(!a)return;
    const b=barns.find(x=>x.id===a.barn_id),k=masters.find(x=>x.id===a.master_contract_id),ls=linksFor(a.id);
    let detail='<div class="contract-detail-head"><div><strong>'+esc(b?shortBarnLabel(b):'-')+' · '+esc(assignmentCycleLabel(allAssignments,a))+'</strong><div class="muted">'+esc(shortContractLabel(k?.number)||'-')+' · '+esc(a.performance_template_name||'-')+'</div></div><span class="pill">AKTIF</span></div>';
    detail+='<div class="return-grid">'+
      '<label>Tanggal Mulai<input type="date" data-start-date="'+esc(a.id)+'" value="'+esc(a.start_date||'')+'"></label>'+ 
      '<label>PPL Penanggung Jawab<select data-ppl-id="'+esc(a.id)+'"><option value="">Pilih PPL</option>'+ppls.map(x=>'<option value="'+esc(x.user_id)+'" '+(x.user_id===a.ppl_id?'selected':'')+'>'+esc(x.full_name)+'</option>').join('')+'</select></label>'+
      '<div class="inline-actions contract-detail-actions"><button type="button" data-save-logistics-start="'+esc(a.id)+'">Simpan Tanggal</button><button type="button" data-save-ppl="'+esc(a.id)+'">Simpan PPL</button></div>'+
    '</div>';
    detail+='<h4>ABK Kandang</h4>';
    detail+=ls.length?ls.map(x=>'<div class="contract-abk-row"><div><strong>'+esc(abkName(x.abk_id))+'</strong><div class="muted">Populasi Awal</div></div><input type="text" data-number="1" inputmode="decimal" data-abk-pop="'+esc(x.id)+'" value="'+(x.initial_birds?fmtNumber(x.initial_birds):'')+'" placeholder="Ekor"><div class="table-actions"><button type="button" data-save-abk-pop="'+esc(x.id)+'">Simpan</button><button type="button" class="btn-danger-soft" data-remove-abk="'+esc(x.id)+'">Hapus</button></div></div>').join(''):'<p class="muted">Belum ada ABK.</p>';
    detail+='<div class="contract-abk-add"><select data-add-abk-select="'+esc(a.id)+'"><option value="">Tambah ABK...</option>'+abks.filter(x=>!ls.some(l=>l.abk_id===x.id)).map(x=>'<option value="'+esc(x.id)+'">'+esc(x.code+' · '+x.name)+'</option>').join('')+'</select><input type="text" data-number="1" inputmode="decimal" data-add-abk-pop="'+esc(a.id)+'" placeholder="Populasi Awal"><button type="button" data-add-abk="'+esc(a.id)+'">Tambah ABK</button></div>';
    detailBody.innerHTML=detail;
    detailPanel.hidden=false;
    bindNumberInputs();
    bindContractDetailActions();
    detailPanel.scrollIntoView({behavior:'smooth',block:'start'});
  };

  const bindContractDetailActions=()=>{
    detailBody.querySelectorAll('[data-add-abk]').forEach(btn=>btn.onclick=async()=>{
      const select=detailBody.querySelector('[data-add-abk-select="'+btn.dataset.addAbk+'"]');
      const pop=detailBody.querySelector('[data-add-abk-pop="'+btn.dataset.addAbk+'"]');
      const initial=Math.trunc(normalizeInputID(pop?.value)||0);
      if(!select?.value)return msg('Pilih ABK yang akan ditambahkan.');
      if(initial<=0)return msg('Populasi Awal ABK wajib diisi.');
      const {error}=await db.from('logistics_contract_assignment_abks').insert({contract_assignment_id:btn.dataset.addAbk,abk_id:select.value,initial_birds:initial});
      if(error)return msg(error.message);
      await logisticsContractPage();msg('ABK dan Populasi Awal berhasil ditambahkan.',true);
    });
    detailBody.querySelectorAll('[data-save-abk-pop]').forEach(btn=>btn.onclick=async()=>{
      const input=detailBody.querySelector('[data-abk-pop="'+btn.dataset.saveAbkPop+'"]');
      const initial=Math.trunc(normalizeInputID(input?.value)||0);
      if(initial<=0)return msg('Populasi Awal ABK wajib lebih dari 0.');
      const {error}=await db.from('logistics_contract_assignment_abks').update({initial_birds:initial}).eq('id',btn.dataset.saveAbkPop);
      if(error)return msg(error.message);
      await logisticsContractPage();msg('Populasi Awal ABK diperbarui.',true);
    });
    detailBody.querySelectorAll('[data-remove-abk]').forEach(btn=>btn.onclick=async()=>{
      const {error}=await db.from('logistics_contract_assignment_abks').delete().eq('id',btn.dataset.removeAbk);
      if(error)return msg(error.message);
      await logisticsContractPage();msg('ABK dilepas dari kontrak kandang.',true);
    });
    detailBody.querySelectorAll('[data-save-ppl]').forEach(btn=>btn.onclick=async()=>{
      const select=detailBody.querySelector('[data-ppl-id="'+btn.dataset.savePpl+'"]');
      if(!select?.value)return msg('PPL penanggung jawab wajib dipilih.');
      const {error}=await db.from('logistics_contract_assignments').update({ppl_id:select.value}).eq('id',btn.dataset.savePpl);
      if(error)return msg(error.message);
      await logisticsContractPage();msg('PPL penanggung jawab diperbarui.',true);
    });
    detailBody.querySelectorAll('[data-save-logistics-start]').forEach(btn=>btn.onclick=async()=>{
      const input=detailBody.querySelector('[data-start-date="'+btn.dataset.saveLogisticsStart+'"]');
      const value=input?.value||'';
      if(!value)return msg('Tanggal mulai wajib diisi.');
      const {error}=await db.from('logistics_contract_assignments').update({start_date:value}).eq('id',btn.dataset.saveLogisticsStart);
      if(error)return msg(error.message);
      await logisticsContractPage();msg('Tanggal mulai diperbarui.',true);
    });
  };

  root.querySelectorAll('[data-contract-detail]').forEach(btn=>btn.onclick=()=>renderContractDetail(btn.dataset.contractDetail));

}

async function logisticsShippingPage(editId=null){
  const [br,ir,sr,sir,ar,kr]=await Promise.all([
    db.from('barns').select('id,code,name,location,kind,active').eq('active',true).order('code',{ascending:true}),
    db.from('items').select('id,code,name,category,feed_phase,unit,kg_per_unit,active').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_shipments').select('*').order('shipment_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('logistics_shipment_items').select('*').order('created_at',{ascending:false}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,performance_template_name,active,created_at').order('created_at',{ascending:false}),
    db.from('contracts').select('id,number,pre_starter_price,starter_price,finisher_price,doc_price,ovk_price_basis,ovk_price,ovk_vat_percent').is('cycle_id',null)
  ]);

  const barns=br.data||[], itemsAll=ir.data||[], shipments=sr.data||[], shipmentItems=sir.data||[], assignments=ar.data||[], masters=kr.data||[];
  const txnShipping=txnListState(shipments,'shipping','shipment_date',5,barns),shownShipments=txnShipping.rows;
  const activeAssignments=assignments.filter(a=>a.active);
  const activeByBarn=new Map(activeAssignments.map(a=>[a.barn_id,a]));
  const selectableBarns=barns.filter(b=>activeByBarn.has(b.id));
  const selected=editId?shipments.find(x=>x.id===editId):null;
  const selectedAssignment=selected?assignments.find(a=>a.id===selected.contract_assignment_id):null;
  const locked=selected?selectedAssignment?.active===false:false;
  let draftItems=selected?shipmentItems.filter(x=>x.shipment_id===selected.id).map(x=>({item_id:x.item_id,quantity:x.quantity,unit_price:x.unit_price,id:x.id})):[];
  window.__logisticsDraftItems=draftItems;

  const todayID=()=>new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  let html='<section class="panel"><h3>Pengiriman</h3>'+
    '<p class="muted">Buat Kontrak Logistik adalah periode kerja. Pilih kandang yang memiliki kontrak aktif, isi No. SJ, lalu tambahkan Sapronak dan jumlah kiriman.</p>'+
    '<form id="logisticsShippingForm" class="form-vertical">'+
      '<input type="hidden" name="shipment_id" value="'+(selected?esc(selected.id):'')+'">'+
      '<label>Cari / Pilih Kandang<input id="shippingBarnSearch" autocomplete="off" placeholder="Contoh: cicurug" value="'+(selected?esc((barns.find(b=>b.id===selected.barn_id)?.code||'')+' · '+(barns.find(b=>b.id===selected.barn_id)?.name||'')):'')+'" '+(locked?'disabled':'')+' required></label>'+
      '<input type="hidden" name="barn_id" id="shippingBarnId" value="'+(selected?esc(selected.barn_id):'')+'">'+
      '<div id="shippingBarnSuggestions" class="search-suggestions"></div>'+
      '<label>Tanggal Pengiriman<input type="date" name="shipment_date" value="'+esc(selected?.shipment_date||todayID())+'" '+(locked?'disabled':'')+' required></label>'+
      '<label>No. SJ Kiriman<input name="shipping_note_number" value="'+esc(selected?.shipping_note_number||'')+'" '+(locked?'disabled':'')+' required></label>'+
      '<label>Catatan<textarea name="notes" '+(locked?'disabled':'')+'>'+esc(selected?.notes||'')+'</textarea></label>'+
    '</form>';

  if(!locked){
    html+='<div class="form-vertical compact-form" id="shippingItemAdder">'+
      '<label>Cari / Pilih Sapronak<input id="shippingItemSearch" autocomplete="off" placeholder="Ketik kode atau nama sapronak"></label>'+
      '<input type="hidden" id="shippingItem">'+
      '<div id="shippingItemSuggestions" class="search-suggestions"></div>'+
      '<label id="shippingQtyLabel">Jumlah<input id="shippingQty" data-number="1" inputmode="decimal" placeholder="Masukkan jumlah"></label>'+
      '<label>Harga Kontrak / Satuan<input id="shippingPrice" data-number="1" inputmode="decimal" placeholder="Otomatis dari kontrak"></label>'+
      '<p id="shippingQtyInfo" class="muted"></p>'+
      '<button type="button" id="addShippingItem">Tambah Sapronak</button>'+
    '</div>';
  }

  html+='<div class="tablewrap"><table><thead><tr><th>Kode</th><th>Sapronak</th><th>Jumlah</th><th>Satuan</th><th>Kg</th><th>Harga/Satuan</th><th>Total</th>'+(locked?'':'<th>Aksi</th>')+'</tr></thead><tbody id="shippingDraftBody"></tbody></table></div>';

  if(locked){
    html+='<p><strong>Status: Terkunci</strong> — Kontrak Logistik periode ini sudah CLOSED.</p>';
  }else{
    html+='<button type="button" id="saveShippingDraft">Simpan Draft</button>';
    if(selected) html+=' <button type="button" id="cancelShippingEdit">Batal Edit</button>';
  }
  html+='</section>';

  html+='<section class="panel"><h3>Riwayat Pengiriman</h3>'+txnShipping.controls+'<div class="tablewrap"><table><thead><tr><th>Kandang</th><th>Tanggal</th><th>No. SJ</th><th>Sapronak</th><th>Jumlah</th><th>Satuan</th><th>Kg</th><th>Harga/Satuan</th><th>Total</th><th>Status</th><th>Aksi</th></tr></thead><tbody>'+
    shownShipments.flatMap(s=>{
      const b=barns.find(x=>x.id===s.barn_id), a=assignments.find(x=>x.id===s.contract_assignment_id);
      const isLocked=a?.active===false;
      const details=shipmentItems.filter(x=>x.shipment_id===s.id);
      if(!details.length){
        return ['<tr><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td>'+esc(s.shipment_date||'-')+'</td><td>'+esc(s.shipping_note_number||'-')+'</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>'+(isLocked?'Terkunci':'Draft')+'</td><td>'+(isLocked?'<button type="button" data-view-shipment="'+esc(s.id)+'">Lihat</button>':'<button type="button" data-view-shipment="'+esc(s.id)+'">Edit</button> <button type="button" data-delete-shipment="'+esc(s.id)+'">Hapus</button>')+'</td></tr>'];
      }
      return details.map((d,idx)=>{
        const i=itemsAll.find(x=>x.id===d.item_id);
        const kg=d.quantity_kg!=null?d.quantity_kg:(i?.category==='PAKAN'?Number(d.quantity)*Number(i.kg_per_unit||50):null);
        return '<tr><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td>'+esc(s.shipment_date||'-')+'</td><td>'+esc(s.shipping_note_number||'-')+'</td><td>'+esc(i?.name||'-')+'</td><td>'+fmtNumber(d.quantity)+'</td><td>'+esc(i?.unit||'-')+'</td><td>'+fmtNumber(kg)+'</td><td>'+fmtNumber(d.unit_price)+'</td><td>'+fmtNumber(Number(d.quantity||0)*Number(d.unit_price||0))+'</td><td>'+(isLocked?'Terkunci':'Draft')+'</td><td>'+(idx===0?(isLocked?'<button type="button" data-view-shipment="'+esc(s.id)+'">Lihat</button>':'<button type="button" data-view-shipment="'+esc(s.id)+'">Edit</button> <button type="button" data-delete-shipment="'+esc(s.id)+'">Hapus</button>'):'')+'</td></tr>';
      });
    }).join('')+
    '</tbody></table></div>'+(!txnShipping.total?'<p>Data pengiriman tidak ditemukan.</p>':'')+txnShipping.pager+'<p class="muted">Riwayat lengkap tersedia di Laporan Logistik.</p></section>';

  layout(html);
  bindNumberInputs();
  bindTxnList(txnShipping,()=>logisticsShippingPage());

  const barnSearch=document.getElementById('shippingBarnSearch');
  const barnIdInput=document.getElementById('shippingBarnId');
  const barnSuggestions=document.getElementById('shippingBarnSuggestions');
  if(barnSearch&&barnIdInput&&barnSuggestions&&!locked){
    const renderShippingBarnSuggestions=()=>{
      const q=(barnSearch.value||'').trim().toLowerCase();
      barnIdInput.value='';
      const rows=q?selectableBarns.filter(x=>{
        const a=activeByBarn.get(x.id), k=masters.find(v=>v.id===a?.master_contract_id);
        const hay=[x.code,x.name,x.location,x.kind,'kontrak aktif',k?.number,a?.performance_template_name].filter(Boolean).join(' ').toLowerCase();
        return hay.includes(q);
      }).slice(0,5):[];
      barnSuggestions.innerHTML=rows.map(x=>{
        const a=activeByBarn.get(x.id), k=masters.find(v=>v.id===a?.master_contract_id);
        return '<button type="button" class="search-suggestion" data-barn-id="'+esc(x.id)+'"><strong>'+esc(x.code+' · '+x.name)+'</strong><br><small>'+esc([x.location,k?.number,a?.performance_template_name].filter(Boolean).join(' · '))+'</small></button>';
      }).join('');
      if(q&&!rows.length)barnSuggestions.innerHTML='<div class="search-empty">Kandang tidak ditemukan atau belum memiliki kontrak aktif.</div>';
      barnSuggestions.querySelectorAll('[data-barn-id]').forEach(btn=>btn.onclick=()=>{
        const b=selectableBarns.find(x=>x.id===btn.dataset.barnId);
        if(!b)return;
        barnSearch.value=shortBarnLabel(b);
        barnIdInput.value=b.id;
        barnSuggestions.innerHTML='';
        if(typeof updateQtyContext==='function')updateQtyContext(true);
      });
    };
    barnSearch.oninput=renderShippingBarnSuggestions;
    barnSearch.onfocus=renderShippingBarnSuggestions;
  }

  const shippingItem=document.getElementById('shippingItem');
  const shippingItemSearch=document.getElementById('shippingItemSearch');
  const shippingItemSuggestions=document.getElementById('shippingItemSuggestions');
  const shippingQty=document.getElementById('shippingQty');
  const shippingPrice=document.getElementById('shippingPrice');
  const shippingQtyLabel=document.getElementById('shippingQtyLabel');
  const shippingQtyInfo=document.getElementById('shippingQtyInfo');

  const contractUnitPriceForItem=(item)=>{
    if(!item)return null;
    const barnId=document.getElementById('shippingBarnId')?.value;
    const a=activeByBarn.get(barnId);
    const k=masters.find(v=>v.id===a?.master_contract_id);
    if(!a||!k)return null;
    if(item.category==='PAKAN'){
      const kg=Number(item.kg_per_unit||50);
      const phase=String(item.feed_phase||'').trim().toLowerCase();
      let perKg=0;
      if(phase.includes('pre'))perKg=Number(k.pre_starter_price||0);
      else if(phase.includes('fin'))perKg=Number(k.finisher_price||0);
      else if(phase.includes('starter'))perKg=Number(k.starter_price||0);
      return perKg>0&&kg>0?perKg*kg:null;
    }
    if(item.category==='DOC'){
      const p=Number(k.doc_price||0);
      return p>0?p:null;
    }
    if(item.category==='OVK'&&k.ovk_price_basis==='FIXED'){
      const p=Number(k.ovk_price||0);
      return p>0?p:null;
    }
    return null;
  };

  const updateQtyContext=(forcePrice=false)=>{
    if(!shippingItem||!shippingQtyLabel||!shippingQtyInfo)return;
    const item=itemsAll.find(x=>x.id===shippingItem.value);
    if(!item){
      shippingQtyLabel.firstChild.textContent='Jumlah';
      shippingQtyInfo.textContent='';
      return;
    }
    shippingQtyLabel.firstChild.textContent='Jumlah ('+(item.unit||'-')+')';
    const autoPrice=contractUnitPriceForItem(item);
    if(shippingPrice){
      const autoLocked=autoPrice!=null&&(item.category==='DOC'||item.category==='PAKAN'||item.category==='OVK');
      shippingPrice.readOnly=!!autoLocked;
      if(autoPrice!=null&&(forcePrice||!shippingPrice.value||autoLocked)){
        shippingPrice.value=formatInputID(String(autoPrice));
      }
      if(autoPrice==null&&item.category==='OVK'){
        shippingPrice.readOnly=false;
      }
    }
    if(item.category==='PAKAN'){
      const kg=Number(item.kg_per_unit||50);
      shippingQtyInfo.textContent=autoPrice!=null
        ?'Pakan: 1 '+(item.unit||'ZAK')+' = '+fmtNumber(kg)+' kg. Harga kontrak otomatis: Rp '+fmtNumber(autoPrice)+' / '+(item.unit||'ZAK')+'. Bisa dikoreksi sebelum Close.'
        :'Harga kontrak belum ditemukan untuk kandang/fase pakan ini. Pilih kandang aktif yang memiliki kontrak.';
    }else if(item.category==='DOC'){
      shippingQtyInfo.textContent=autoPrice!=null
        ?'Harga DOC kontrak otomatis: Rp '+fmtNumber(autoPrice)+' / '+(item.unit||'EKOR')+'. Bisa dikoreksi sebelum Close.'
        :'Harga DOC kontrak belum ditemukan.';
    }else if(item.category==='OVK'){
      const barnId=document.getElementById('shippingBarnId')?.value;
      const a=activeByBarn.get(barnId);
      const k=masters.find(v=>v.id===a?.master_contract_id);
      if(autoPrice!=null)shippingQtyInfo.textContent='OVK: harga tetap kontrak otomatis Rp '+fmtNumber(autoPrice)+' / '+(item.unit||'satuan')+'.';
      else shippingQtyInfo.textContent='OVK: dasar kontrak Distributor + PPN'+(k?.ovk_vat_percent!=null?' '+fmtNumber(k.ovk_vat_percent)+'%':'')+'. Isi Harga/Satuan final sesuai invoice.';
    }else shippingQtyInfo.textContent='Satuan kiriman: '+(item.unit||'-');
  };
  if(shippingItemSearch&&shippingItemSuggestions&&shippingItem){
    const renderShippingItemSuggestions=()=>{
      const q=(shippingItemSearch.value||'').trim().toLowerCase();
      shippingItem.value='';
      const rows=q?itemsAll.filter(x=>[x.code,x.name,x.category,x.unit].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5):[];
      shippingItemSuggestions.innerHTML=rows.map(x=>'<button type="button" class="search-suggestion" data-shipping-item="'+esc(x.id)+'"><strong>'+esc(x.code+' · '+x.name)+'</strong><br><small>'+esc([x.category,x.unit].filter(Boolean).join(' · '))+'</small></button>').join('');
      if(q&&!rows.length)shippingItemSuggestions.innerHTML='<div class="search-empty">Sapronak tidak ditemukan.</div>';
      shippingItemSuggestions.querySelectorAll('[data-shipping-item]').forEach(btn=>btn.onclick=()=>{
        const item=itemsAll.find(x=>x.id===btn.dataset.shippingItem);
        if(!item)return;
        shippingItem.value=item.id;
        shippingItemSearch.value=item.code+' · '+item.name;
        shippingItemSuggestions.innerHTML='';
        if(shippingPrice)shippingPrice.value='';
        updateQtyContext(true);
      });
      if(shippingPrice)shippingPrice.value='';
      updateQtyContext();
    };
    shippingItemSearch.oninput=renderShippingItemSuggestions;
    shippingItemSearch.onfocus=renderShippingItemSuggestions;
  }
  updateQtyContext();

  const renderDraftItems=()=>{
    const body=document.getElementById('shippingDraftBody'); if(!body)return;
    const arr=window.__logisticsDraftItems||[];
    body.innerHTML=arr.map((x,idx)=>{
      const i=itemsAll.find(v=>v.id===x.item_id);
      const kg=i?.category==='PAKAN'?Number(x.quantity)*Number(i.kg_per_unit||50):null;
      return '<tr><td>'+esc(i?.code||'-')+'</td><td>'+esc(i?.name||'-')+'</td><td>'+fmtNumber(x.quantity)+'</td><td>'+esc(i?.unit||'-')+'</td><td>'+fmtNumber(kg)+'</td><td>'+fmtNumber(x.unit_price)+'</td><td>'+fmtNumber(Number(x.quantity||0)*Number(x.unit_price||0))+'</td>'+
        (locked?'':'<td><button type="button" data-remove-draft="'+idx+'">Hapus</button></td>')+'</tr>';
    }).join('');
    if(!locked) body.querySelectorAll('[data-remove-draft]').forEach(btn=>btn.onclick=()=>{
      const arr=window.__logisticsDraftItems||[];
      arr.splice(Number(btn.dataset.removeDraft),1);
      renderDraftItems();
    });
  };
  renderDraftItems();

  if(!locked){
    document.getElementById('addShippingItem').onclick=()=>{
      const itemId=shippingItem.value;
      const qty=normalizeInputID(shippingQty.value);
      let price=normalizeInputID(shippingPrice?.value||'');
      if(!itemId||qty==null||qty<=0)return msg('Pilih Sapronak dan isi jumlah kiriman yang benar.');
      {
        const item=itemsAll.find(x=>x.id===itemId);
        const autoPrice=contractUnitPriceForItem(item);
        if(autoPrice!=null){
          price=autoPrice;
          if(shippingPrice)shippingPrice.value=formatInputID(String(autoPrice));
        }
      }
      if(price==null||price<0)return msg('Harga kontrak tidak ditemukan. Periksa kandang aktif dan Master Kontrak.');
      const arr=window.__logisticsDraftItems||[];
      const exists=arr.find(x=>x.item_id===itemId&&Number(x.unit_price||0)===Number(price));
      if(exists) exists.quantity=Number(exists.quantity)+Number(qty);
      else arr.push({item_id:itemId,quantity:qty,unit_price:price});
      shippingItem.value='';
      if(shippingItemSearch)shippingItemSearch.value='';
      if(shippingItemSuggestions)shippingItemSuggestions.innerHTML='';
      shippingQty.value='';
      if(shippingPrice)shippingPrice.value='';
      updateQtyContext();
      renderDraftItems();
    };

    document.getElementById('saveShippingDraft').onclick=async()=>{
      const fd=new FormData(document.getElementById('logisticsShippingForm'));
      const barnId=fd.get('barn_id');
      const assignment=activeByBarn.get(barnId);
      const arr=window.__logisticsDraftItems||[];
      if(!barnId)return msg('Pilih kandang.');
      if(!assignment)return msg('Kandang belum memiliki kontrak Logistik aktif.');
      if(!fd.get('shipping_note_number'))return msg('No. SJ Kiriman wajib diisi.');
      const sj=String(fd.get('shipping_note_number')||'').trim();
      const duplicate=shipments.find(x=>String(x.shipping_note_number||'').trim().toLowerCase()===sj.toLowerCase()&&x.id!==fd.get('shipment_id'));
      if(duplicate)return msg('No. SJ '+sj+' sudah pernah digunakan. Gunakan No. SJ lain.');
      if(!arr.length)return msg('Tambahkan minimal satu Sapronak dan jumlah kirimannya.');

      const shipmentId=fd.get('shipment_id')||null;
      const {error:saveError}=await db.rpc('save_logistics_shipment_atomic',{
        p_id:shipmentId,
        p_barn_id:barnId,
        p_assignment_id:assignment.id,
        p_shipment_date:fd.get('shipment_date'),
        p_shipping_note_number:fd.get('shipping_note_number')||null,
        p_notes:fd.get('notes')||null,
        p_items:arr.map(x=>({item_id:x.item_id,quantity:x.quantity,unit_price:x.unit_price}))
      });
      if(saveError)return msg(saveError.message);

      window.__logisticsDraftItems=[];
      await logisticsShippingPage();
      msg(shipmentId?'Pengiriman berhasil diperbarui.':'Draft pengiriman tersimpan.',true);
    };
    if(selected) document.getElementById('cancelShippingEdit').onclick=()=>logisticsShippingPage();
  }

  root.querySelectorAll('[data-view-shipment]').forEach(btn=>btn.onclick=()=>logisticsShippingPage(btn.dataset.viewShipment));
  root.querySelectorAll('[data-delete-shipment]').forEach(btn=>btn.onclick=async()=>{
    if(!confirm('Hapus draft pengiriman ini?'))return;
    const {error}=await db.from('logistics_shipments').delete().eq('id',btn.dataset.deleteShipment);
    if(error)return msg(error.message);
    await logisticsShippingPage();
    msg('Draft pengiriman dihapus.',true);
  });
  const err=br.error||ir.error||sr.error||sir.error||ar.error||kr.error;
  if(err)msg(err.message);
}

async function logisticsExternalShippingPage(editId=null){
  const [br,sr,ir,ar,hr,hir]=await Promise.all([
    db.from('barns').select('id,code,name,location,active').eq('active',true).order('code',{ascending:true}),
    db.from('suppliers').select('id,code,name,active,supplier_type').eq('active',true).eq('supplier_type','SAPRONAK').order('code',{ascending:true}),
    db.from('items').select('id,code,name,category,feed_phase,unit,kg_per_unit,supplier_id,active').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,active,start_date').order('created_at',{ascending:false}),
    db.from('logistics_external_shipments').select('*').order('shipment_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('logistics_external_shipment_items').select('*').order('created_at',{ascending:false})
  ]);
  const barns=br.data||[], supplierRows=sr.data||[], itemRows=ir.data||[], assignments=ar.data||[];
  const headers=hr.data||[], detailRows=hir.data||[];
  const txnExternal=txnListState(headers,'externalSapronak','shipment_date',5,barns),shownHeaders=txnExternal.rows;
  const activeAssignments=assignments.filter(a=>a.active);
  const activeByBarn=new Map(activeAssignments.map(a=>[a.barn_id,a]));
  const allowedBarns=barns.filter(b=>activeByBarn.has(b.id));
  const selected=editId?headers.find(h=>h.id===editId):null;
  const selectedDetail=selected?detailRows.find(d=>d.external_shipment_id===selected.id):null;
  const selectedItem=selectedDetail?itemRows.find(i=>i.id===selectedDetail.item_id):null;
  const todayID=()=>new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  let html='<section class="panel"><h3>'+(selected?'Edit Tambah Sapronak':'Tambah Sapronak')+'</h3>'+
    '<p class="muted">Jumlah dicatat dalam satuan barang. Konversi Kg/Satuan dari Master Sapronak. Harga/Satuan dan Harga/Kg dihitung otomatis.</p>'+
    '<form id="externalShippingForm" class="form-vertical">'+
      '<input type="hidden" name="header_id" value="'+esc(selected?.id||'')+'">'+
      '<input type="hidden" name="detail_id" value="'+esc(selectedDetail?.id||'')+'">'+
      '<label>Cari / Pilih Kandang<input id="externalBarnSearch" autocomplete="off" placeholder="Contoh: cicurug" value="'+(selected?esc(shortBarnLabel(barns.find(b=>b.id===selected.barn_id))):'')+'" required></label>'+
      '<input type="hidden" name="barn_id" id="externalBarnId" value="'+esc(selected?.barn_id||'')+'">'+
      '<div id="externalBarnSuggestions" class="search-suggestions"></div>'+
      '<label>Tanggal Kiriman<input type="date" name="shipment_date" value="'+esc(selected?.shipment_date||todayID())+'" required></label>'+
      '<label>Supplier<select name="supplier_id" id="externalSupplier" required><option value="">Pilih Supplier</option>'+
        supplierRows.map(s=>'<option value="'+esc(s.id)+'" '+(selected?.supplier_id===s.id?'selected':'')+'>'+esc(s.code+' · '+s.name)+'</option>').join('')+
      '</select></label>'+
      '<label>Cari / Pilih Sapronak<input id="externalItemSearch" autocomplete="off" placeholder="Pilih supplier lalu ketik kode / nama" value="'+esc(selectedItem?(selectedItem.code+' · '+selectedItem.name):'')+'"></label>'+
      '<input type="hidden" name="item_id" id="externalItem" value="'+esc(selectedDetail?.item_id||'')+'">'+
      '<div id="externalItemSuggestions" class="search-suggestions"></div>'+
      '<label>Jumlah (Satuan)<input name="quantity" id="externalQty" data-number="1" inputmode="decimal" value="'+(selectedDetail?fmtNumber(selectedDetail.quantity):'')+'" required></label>'+
      '<label>Konversi Kg / Satuan<input id="externalKgPerUnit" readonly tabindex="-1"></label>'+
      '<label>Total Berat (Kg)<input id="externalTotalKg" readonly tabindex="-1"></label>'+
      '<label>Harga Beli / Satuan<input name="purchase_unit_price" id="externalPrice" data-number="1" inputmode="decimal" value="'+(selectedDetail?fmtNumber(selectedDetail.purchase_unit_price):'')+'" required></label>'+
      '<label>Harga Beli / Kg<input id="externalPriceKg" data-number="1" inputmode="decimal" placeholder="Otomatis dari harga/satuan"></label>'+
      '<label>Total Pembelian<input id="externalTotal" readonly tabindex="-1"></label>'+
      '<label>No. Nota / Referensi<input name="reference_number" value="'+esc(selected?.reference_number||'')+'"></label>'+
      '<label>Catatan<textarea name="notes">'+esc(selected?.notes||'')+'</textarea></label>'+
      '<button type="submit">'+(selected?'Simpan Perubahan':'Simpan Tambah Sapronak')+'</button>'+
      (selected?' <button type="button" id="cancelExternalEdit">Batal Edit</button>':'')+
    '</form></section>';

  html+='<section class="panel"><h3>Riwayat Tambah Sapronak</h3>'+txnExternal.controls+'<div class="tablewrap"><table><thead><tr>'+
    '<th>Tanggal</th><th>Kandang</th><th>Supplier</th><th>Sapronak</th><th>Jumlah</th><th>Satuan</th><th>Kg/Satuan</th><th>Total Kg</th><th>Harga/Satuan</th><th>Harga/Kg</th><th>Total</th><th>Referensi</th><th>Aksi</th>'+
    '</tr></thead><tbody>'+
    shownHeaders.map(h=>{
      const b=barns.find(x=>x.id===h.barn_id);
      const s=supplierRows.find(x=>x.id===h.supplier_id);
      const d=detailRows.find(x=>x.external_shipment_id===h.id);
      const it=d?itemRows.find(x=>x.id===d.item_id):null;
      const total=d?Number(d.quantity||0)*Number(d.purchase_unit_price||0):0;
      const a=assignments.find(v=>v.id===h.contract_assignment_id);
      const isLocked=!a?.active;
      const kgPerUnit=Number(it?.kg_per_unit||0);
      const priceKg=kgPerUnit>0?Number(d?.purchase_unit_price||0)/kgPerUnit:null;
      return '<tr><td>'+esc(h.shipment_date||'')+'</td><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td>'+esc(s?s.name:'-')+'</td><td>'+esc(it?it.code+' · '+it.name:'-')+'</td><td>'+fmtNumber(d?.quantity)+'</td><td>'+esc(it?.unit||'-')+'</td><td>'+(kgPerUnit>0?fmtNumber(kgPerUnit):'-')+'</td><td>'+fmtNumber(d?.quantity_kg)+'</td><td>Rp '+fmtNumber(d?.purchase_unit_price)+'</td><td>'+(priceKg==null?'-':'Rp '+fmtNumber(priceKg))+'</td><td>Rp '+fmtNumber(total)+'</td><td>'+esc(h.reference_number||'-')+'</td><td>'+(isLocked?'<strong>Terkunci</strong>':'<button type="button" data-edit-external="'+esc(h.id)+'">Edit</button> <button type="button" data-delete-external="'+esc(h.id)+'">Hapus</button>')+'</td></tr>';
    }).join('')+
    '</tbody></table></div>'+(!txnExternal.total?'<p>Data Tambah Sapronak tidak ditemukan.</p>':'')+txnExternal.pager+'</section>';

  layout(html);
  [br,sr,ir,ar,hr,hir].forEach(x=>{if(x.error)msg(x.error.message)});
  bindNumberInputs();
  bindTxnList(txnExternal,()=>logisticsExternalShippingPage());

  const form=document.getElementById('externalShippingForm');
  const externalBarnSearch=document.getElementById('externalBarnSearch');
  const externalBarnId=document.getElementById('externalBarnId');
  const externalBarnSuggestions=document.getElementById('externalBarnSuggestions');
  if(externalBarnSearch&&externalBarnId&&externalBarnSuggestions){
    externalBarnSearch.oninput=()=>{
      const q=(externalBarnSearch.value||'').trim().toLowerCase();
      externalBarnId.value='';
      const rows=q?allowedBarns.filter(b=>[b.code,b.name,b.location].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5):[];
      externalBarnSuggestions.innerHTML=rows.map(b=>'<button type="button" class="search-suggestion" data-external-barn="'+esc(b.id)+'"><strong>'+esc(shortBarnLabel(b))+'</strong><small>'+esc(b.location||'')+'</small></button>').join('');
      if(q&&!rows.length)externalBarnSuggestions.innerHTML='<div class="search-empty">Kandang aktif tidak ditemukan.</div>';
      externalBarnSuggestions.querySelectorAll('[data-external-barn]').forEach(btn=>btn.onclick=()=>{
        const b=allowedBarns.find(x=>x.id===btn.dataset.externalBarn);if(!b)return;
        externalBarnId.value=b.id;externalBarnSearch.value=shortBarnLabel(b);externalBarnSuggestions.innerHTML='';
      });
    };
  }

  const supplierEl=document.getElementById('externalSupplier');
  const itemEl=document.getElementById('externalItem');
  const itemSearchEl=document.getElementById('externalItemSearch');
  const itemSuggestionsEl=document.getElementById('externalItemSuggestions');
  const qtyEl=document.getElementById('externalQty');
  const kgPerUnitEl=document.getElementById('externalKgPerUnit');
  const totalKgEl=document.getElementById('externalTotalKg');
  const priceEl=document.getElementById('externalPrice');
  const priceKgEl=document.getElementById('externalPriceKg');
  const totalEl=document.getElementById('externalTotal');
  let priceSource='unit';

  const currentItem=()=>itemRows.find(i=>i.id===itemEl.value);
  const calcAll=()=>{
    const it=currentItem();
    const kg=Number(it?.kg_per_unit||0);
    const q=normalizeInputID(qtyEl.value)||0;
    let unitPrice=normalizeInputID(priceEl.value)||0;
    let kgPrice=normalizeInputID(priceKgEl.value)||0;
    kgPerUnitEl.value=kg>0?fmtNumber(kg)+' Kg':'Tidak memakai konversi Kg';
    totalKgEl.value=q&&kg>0?fmtNumber(q*kg):'';
    priceKgEl.disabled=!(kg>0);
    if(kg>0){
      if(priceSource==='kg'&&kgPrice>0){
        unitPrice=kgPrice*kg;
        priceEl.value=fmtNumber(unitPrice);
      }else if(unitPrice>0){
        kgPrice=unitPrice/kg;
        priceKgEl.value=fmtNumber(kgPrice);
      }
    }else{
      priceKgEl.value='';
    }
    totalEl.value=q&&unitPrice?'Rp '+fmtNumber(q*unitPrice):'';
  };
  const renderExternalItemSuggestions=()=>{
    const sid=supplierEl.value;
    const q=(itemSearchEl?.value||'').trim().toLowerCase();
    if(!sid){
      itemEl.value='';
      if(itemSuggestionsEl)itemSuggestionsEl.innerHTML='<div class="search-empty">Pilih Supplier terlebih dahulu.</div>';
      calcAll();
      return;
    }
    const filtered=q?itemRows.filter(i=>i.supplier_id===sid && [i.code,i.name,i.category,i.unit].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5):[];
    if(itemSuggestionsEl){
      itemSuggestionsEl.innerHTML=filtered.map(i=>'<button type="button" class="search-suggestion" data-external-item="'+esc(i.id)+'"><strong>'+esc(i.code+' · '+i.name)+'</strong><br><small>'+esc([i.category,i.unit,i.kg_per_unit?fmtNumber(i.kg_per_unit)+' Kg':null].filter(Boolean).join(' · '))+'</small></button>').join('');
      if(q&&!filtered.length)itemSuggestionsEl.innerHTML='<div class="search-empty">Sapronak tidak ditemukan untuk Supplier ini.</div>';
      itemSuggestionsEl.querySelectorAll('[data-external-item]').forEach(btn=>btn.onclick=()=>{
        const item=itemRows.find(i=>i.id===btn.dataset.externalItem);
        if(!item)return;
        itemEl.value=item.id;
        itemSearchEl.value=item.code+' · '+item.name;
        itemSuggestionsEl.innerHTML='';
        priceSource='unit';
        calcAll();
      });
    }
  };
  const refreshItems=()=>{
    const current=itemRows.find(i=>i.id===itemEl.value);
    if(!current||current.supplier_id!==supplierEl.value){
      itemEl.value='';
      if(itemSearchEl)itemSearchEl.value='';
    }
    if(itemSuggestionsEl)itemSuggestionsEl.innerHTML='';
    calcAll();
  };

  supplierEl.onchange=()=>{refreshItems();};
  if(itemSearchEl){
    itemSearchEl.oninput=()=>{itemEl.value='';renderExternalItemSuggestions();calcAll();};
    itemSearchEl.onfocus=renderExternalItemSuggestions;
  }
  qtyEl.addEventListener('input',calcAll);
  priceEl.addEventListener('input',()=>{priceSource='unit';calcAll();});
  priceKgEl.addEventListener('input',()=>{priceSource='kg';calcAll();});

  if(supplierEl.value)refreshItems();
  if(selectedDetail){
    itemEl.value=selectedDetail.item_id;
    if(itemSearchEl&&selectedItem)itemSearchEl.value=selectedItem.code+' · '+selectedItem.name;
    calcAll();
  }

  form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form);
    const barnId=fd.get('barn_id');
    const assignment=activeByBarn.get(barnId);
    if(!assignment)return msg('Kandang belum memiliki kontrak Logistik aktif.');
    const supplierId=fd.get('supplier_id');
    const itemId=fd.get('item_id');
    const it=itemRows.find(i=>i.id===itemId);
    if(!it||it.supplier_id!==supplierId)return msg('Sapronak tidak sesuai Supplier.');
    const quantity=normalizeInputID(fd.get('quantity'));
    const price=normalizeInputID(fd.get('purchase_unit_price'));
    if(!(quantity>0))return msg('Jumlah harus lebih dari 0.');
    if(price===null||price<0)return msg('Harga beli tidak valid.');

    const headerId=fd.get('header_id')||null;
    const detailId=fd.get('detail_id')||null;
    const {error:saveError}=await db.rpc('save_external_sapronak_atomic',{
      p_header_id:headerId,
      p_detail_id:detailId,
      p_assignment_id:assignment.id,
      p_barn_id:barnId,
      p_supplier_id:supplierId,
      p_shipment_date:fd.get('shipment_date'),
      p_reference_number:fd.get('reference_number')||null,
      p_notes:fd.get('notes')||null,
      p_item_id:itemId,
      p_quantity:quantity,
      p_purchase_unit_price:price
    });
    if(saveError)return msg(saveError.message);
    await logisticsExternalShippingPage();
    msg(headerId?'Tambah Sapronak berhasil diperbarui.':'Tambah Sapronak berhasil disimpan.',true);
  };

  document.querySelectorAll('[data-edit-external]').forEach(btn=>btn.onclick=()=>logisticsExternalShippingPage(btn.dataset.editExternal));
  document.querySelectorAll('[data-delete-external]').forEach(btn=>btn.onclick=async()=>{
    if(!confirm('Hapus data Tambah Sapronak ini?'))return;
    const {error}=await db.from('logistics_external_shipments').delete().eq('id',btn.dataset.deleteExternal);
    if(error)return msg(error.message);
    await logisticsExternalShippingPage();
    msg('Data Tambah Sapronak berhasil dihapus.',true);
  });
  const cancel=document.getElementById('cancelExternalEdit');
  if(cancel)cancel.onclick=()=>logisticsExternalShippingPage();
}
async function marketingContractHarvestPage(editId=null){
  const [br,ar,cr,hr,lpr]=await Promise.all([
    db.from('barns').select('id,code,name,active').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active').order('start_date',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('marketing_contract_harvests').select('*').order('harvested_on',{ascending:false}).order('created_at',{ascending:false}),
    db.from('contract_live_prices').select('contract_id,min_weight_kg,max_weight_kg,price_per_kg').order('min_weight_kg')
  ]);
  const barns=br.data||[],assignments=ar.data||[],contractsRows=cr.data||[],rows=hr.data||[],livePrices=lpr.data||[];
  const txnHarvest=txnListState(rows,'marketingHarvest','harvested_on',5,barns,'barn_id',{assignmentKey:'contract_assignment_id',assignments:assignments.map(a=>({id:a.id,barn_id:a.barn_id,label:assignmentCycleLabel(assignments,a)+' · '+(a.active?'AKTIF':'CLOSED')}))}),pageRows=txnHarvest.rows;
  const activeAssignments=assignments.filter(a=>a.active);
  const activeByBarn=new Map(activeAssignments.map(a=>[a.barn_id,a]));
  const allowedBarns=barns.filter(b=>activeByBarn.has(b.id));
  const selected=editId?rows.find(x=>x.id===editId):null;
  const todayID=()=>new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  let html='<section class="panel"><h3>'+(selected?'Edit Panen Kontrak':'Panen Kontrak')+'</h3>'+
    '<p class="muted">Input hasil panen kontrak Marketing. BW rata-rata, harga kontrak, dan total panen dihitung otomatis untuk RHPP.</p>'+
    '<form id="contractHarvestForm" class="form-vertical">'+
      '<input type="hidden" name="id" value="'+esc(selected?.id||'')+'">'+
      '<label>Cari / Pilih Kandang<input id="harvestBarnSearch" autocomplete="off" placeholder="Contoh: cicurug" value="'+(selected?esc(shortBarnLabel(barns.find(b=>b.id===selected.barn_id))):'')+'" required></label>'+
      '<input type="hidden" name="barn_id" id="harvestBarnId" value="'+esc(selected?.barn_id||'')+'">'+
      '<div id="harvestBarnSuggestions" class="search-suggestions"></div>'+
      '<label>Tanggal<input type="date" name="harvested_on" value="'+esc(selected?.harvested_on||todayID())+'" required></label>'+
      '<label>Pembeli / RPA<input name="buyer_name" value="'+esc(selected?.buyer_name||'')+'" required></label>'+
      '<label>No Mobil<input name="vehicle_number" value="'+esc(selected?.vehicle_number||'')+'" required></label>'+
      '<label>Ekor<input name="birds" id="contractHarvestBirds" data-number="1" inputmode="decimal" value="'+(selected?fmtNumber(selected.birds):'')+'" required></label>'+
      '<label>KG<input name="net_weight_kg" id="contractHarvestWeight" data-number="1" inputmode="decimal" value="'+(selected?fmtNumber(selected.net_weight_kg):'')+'" required></label>'+
      '<button type="submit">'+(selected?'Simpan Perubahan':'Simpan')+'</button>'+
      (selected?' <button type="button" id="cancelHarvestEdit">Batal Edit</button>':'')+
    '</form></section>';

  html+='<section class="panel"><h3>Riwayat Panen Kontrak</h3>'+txnHarvest.controls+'<div class="tablewrap"><table><thead><tr>'+
    '<th>Tanggal</th><th>Kandang</th><th>Pembeli / RPA</th><th>No Mobil</th><th>Ekor</th><th>KG</th><th>Aksi</th>'+
    '</tr></thead><tbody>'+
    pageRows.map(x=>{
      const b=barns.find(v=>v.id===x.barn_id);
      const a=assignments.find(v=>v.id===x.contract_assignment_id);
      const isLocked=!a?.active;
      return '<tr><td>'+esc(x.harvested_on||'')+'</td><td>'+esc(assignmentIdentity(assignments,barns,contractsRows,a))+'</td><td>'+esc(x.buyer_name||'-')+'</td><td>'+esc(x.vehicle_number||'-')+'</td><td>'+fmtNumber(x.birds)+'</td><td>'+fmtNumber(x.net_weight_kg)+'</td><td>'+(isLocked?'<strong>Terkunci</strong>':'<button type="button" data-edit-harvest="'+esc(x.id)+'">Edit</button> <button type="button" data-delete-harvest="'+esc(x.id)+'">Hapus</button>')+'</td></tr>';
    }).join('')+
    '</tbody></table></div>'+(!txnHarvest.total?'<p>Data Panen Kontrak tidak ditemukan.</p>':'')+txnHarvest.pager+'</section>';

  layout(html);
  [br,ar,cr,hr,lpr].forEach(x=>{if(x.error)msg(x.error.message)});
  bindNumberInputs();
  bindTxnList(txnHarvest,()=>marketingContractHarvestPage());

  const harvestBarnSearch=document.getElementById('harvestBarnSearch');
  const harvestBarnId=document.getElementById('harvestBarnId');
  const harvestBarnSuggestions=document.getElementById('harvestBarnSuggestions');
  if(harvestBarnSearch&&harvestBarnId&&harvestBarnSuggestions){
    harvestBarnSearch.oninput=()=>{
      const q=(harvestBarnSearch.value||'').trim().toLowerCase();
      harvestBarnId.value='';
      const rows=q?allowedBarns.filter(b=>[b.code,b.name].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5):[];
      harvestBarnSuggestions.innerHTML=rows.map(b=>'<button type="button" class="search-suggestion" data-harvest-barn="'+esc(b.id)+'"><strong>'+esc(shortBarnLabel(b))+'</strong></button>').join('');
      if(q&&!rows.length)harvestBarnSuggestions.innerHTML='<div class="search-empty">Kandang aktif tidak ditemukan.</div>';
      harvestBarnSuggestions.querySelectorAll('[data-harvest-barn]').forEach(btn=>btn.onclick=()=>{
        const b=allowedBarns.find(x=>x.id===btn.dataset.harvestBarn);if(!b)return;
        harvestBarnId.value=b.id;harvestBarnSearch.value=shortBarnLabel(b);harvestBarnSuggestions.innerHTML='';
      });
    };
  }

  const form=document.getElementById('contractHarvestForm');
  form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form),barnId=fd.get('barn_id'),assignment=activeByBarn.get(barnId);
    if(!assignment)return msg('Kandang belum memiliki kontrak aktif.');
    const n=normalizeInputID(fd.get('birds')),w=normalizeInputID(fd.get('net_weight_kg'));
    if(!(n>0))return msg('Ekor harus lebih dari 0.');
    if(!(w>0))return msg('KG harus lebih dari 0.');
    const avg=w/n;
    const priceRow=livePrices.find(p=>p.contract_id===assignment.master_contract_id&&avg>=prodNum(p.min_weight_kg)&&(p.max_weight_kg==null||avg<prodNum(p.max_weight_kg)));
    if(!priceRow)return msg('Harga kontrak untuk BW rata-rata '+prodFmt(avg,3)+' Kg belum tersedia.');
    const price=prodNum(priceRow.price_per_kg);
    const payload={
      contract_assignment_id:assignment.id,
      barn_id:barnId,
      harvested_on:fd.get('harvested_on'),
      birds:n,
      net_weight_kg:w,
      price_per_kg:price,
      buyer_name:String(fd.get('buyer_name')||'').trim()||null,
      vehicle_number:String(fd.get('vehicle_number')||'').trim()||null,
      transaction_number:null,
      notes:null
    };
    const id=fd.get('id');
    const q=id?db.from('marketing_contract_harvests').update(payload).eq('id',id):db.from('marketing_contract_harvests').insert(payload);
    const {error}=await q;
    if(error)return msg(error.message);
    await marketingContractHarvestPage();
    msg(id?'Panen Kontrak berhasil diperbarui.':'Panen Kontrak berhasil disimpan.',true);
  };

  document.querySelectorAll('[data-edit-harvest]').forEach(btn=>btn.onclick=()=>marketingContractHarvestPage(btn.dataset.editHarvest));
  document.querySelectorAll('[data-delete-harvest]').forEach(btn=>btn.onclick=async()=>{
    if(!confirm('Hapus data Panen Kontrak ini?'))return;
    const {error}=await db.from('marketing_contract_harvests').delete().eq('id',btn.dataset.deleteHarvest);
    if(error)return msg(error.message);
    await marketingContractHarvestPage();
    msg('Panen Kontrak berhasil dihapus.',true);
  });
  const cancel=document.getElementById('cancelHarvestEdit');if(cancel)cancel.onclick=()=>marketingContractHarvestPage();
}
async function marketingExternalMeatPage(editId=null){
  const [sr,pr,br,ar,cr]=await Promise.all([
    db.from('suppliers').select('id,code,name,active,supplier_type').eq('active',true).eq('supplier_type','DAGING').order('code',{ascending:true}),
    db.from('marketing_external_meat_purchases').select('*').order('purchase_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('barns').select('id,code,name,active').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active').order('start_date',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null)
  ]);
  const supplierRows=sr.data||[], rows=pr.data||[], barnRows=br.data||[], assignments=ar.data||[], contractsRows=cr.data||[];
  const txnMeat=txnListState(rows,'marketingMeat','purchase_date',5,barnRows,'barn_id',{assignmentKey:'contract_assignment_id',assignments:assignments.map(a=>({id:a.id,barn_id:a.barn_id,label:assignmentCycleLabel(assignments,a)+' · '+(a.active?'AKTIF':'CLOSED')}))}),shownMeat=txnMeat.rows;
  const activeAssignments=assignments.filter(a=>a.active);
  const activeByBarn=new Map(activeAssignments.map(a=>[a.barn_id,a]));
  const allowedBarns=barnRows.filter(b=>activeByBarn.has(b.id));
  const selected=editId?rows.find(x=>x.id===editId):null;
  const todayID=()=>new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  let html='<section class="panel"><h3>'+(selected?'Edit Tambah Daging':'Tambah Daging')+'</h3>'+
    '<p class="muted">Pembelian ayam/daging luar untuk mengisi kebutuhan RHPP perusahaan. Wajib dikaitkan ke kandang dan kontrak aktif.</p>'+
    '<form id="externalMeatForm" class="form-vertical">'+
      '<input type="hidden" name="id" value="'+esc(selected?.id||'')+'">'+
      '<label>Cari / Pilih Kandang<input id="meatBarnSearch" autocomplete="off" placeholder="Contoh: cicurug" value="'+(selected?esc(shortBarnLabel(barnRows.find(b=>b.id===selected.barn_id))):'')+'" required></label>'+
      '<input type="hidden" name="barn_id" id="meatBarnId" value="'+esc(selected?.barn_id||'')+'">'+
      '<div id="meatBarnSuggestions" class="search-suggestions"></div>'+
      '<label>Tanggal Pembelian<input type="date" name="purchase_date" value="'+esc(selected?.purchase_date||todayID())+'" required></label>'+
      '<label>Supplier<select name="supplier_id" required><option value="">Pilih Supplier</option>'+
        supplierRows.map(s=>'<option value="'+esc(s.id)+'" '+(selected?.supplier_id===s.id?'selected':'')+'>'+esc(s.code+' · '+s.name)+'</option>').join('')+
      '</select></label>'+
      '<label>Jenis / Nama Barang<input name="product_name" value="'+esc(selected?.product_name||'Daging/Ayam')+'" required></label>'+
      '<label>Berat (Kg)<input name="weight_kg" id="meatWeight" data-number="1" inputmode="decimal" value="'+(selected?fmtNumber(selected.weight_kg):'')+'" required></label>'+
      '<label>Harga Beli / Kg<input name="purchase_price_per_kg" id="meatPrice" data-number="1" inputmode="decimal" value="'+(selected?fmtNumber(selected.purchase_price_per_kg):'')+'" required></label>'+
      '<label>Total Pembelian<input id="meatTotal" readonly tabindex="-1"></label>'+
      '<label>No. Nota / Referensi<input name="reference_number" value="'+esc(selected?.reference_number||'')+'"></label>'+
      '<label>Catatan<textarea name="notes">'+esc(selected?.notes||'')+'</textarea></label>'+
      '<button type="submit">'+(selected?'Simpan Perubahan':'Simpan Tambah Daging')+'</button>'+
      (selected?' <button type="button" id="cancelBlEdit">Batal Edit</button>':'')+
    '</form></section>';

  html+='<section class="panel"><h3>Riwayat Tambah Daging</h3>'+txnMeat.controls+'<div class="tablewrap"><table><thead><tr>'+
    '<th>Tanggal</th><th>Kandang</th><th>Kontrak</th><th>Supplier</th><th>Barang</th><th>Kg</th><th>Harga/Kg</th><th>Total</th><th>Referensi</th><th>Aksi</th>'+
    '</tr></thead><tbody>'+
    shownMeat.map(x=>{
      const s=supplierRows.find(v=>v.id===x.supplier_id),b=barnRows.find(v=>v.id===x.barn_id),a=assignments.find(v=>v.id===x.contract_assignment_id),k=contractsRows.find(v=>v.id===a?.master_contract_id);
      const isLocked=!a?.active;
      const total=Number(x.weight_kg||0)*Number(x.purchase_price_per_kg||0);
      return '<tr><td>'+esc(x.purchase_date||'')+'</td><td>'+esc(assignmentIdentity(assignments,barnRows,contractsRows,a))+'</td><td>'+esc(shortContractLabel(k?.number)||'-')+'</td><td>'+esc(s?s.name:'-')+'</td><td>'+esc(x.product_name||'')+'</td><td>'+fmtNumber(x.weight_kg)+'</td><td>Rp '+fmtNumber(x.purchase_price_per_kg)+'</td><td>Rp '+fmtNumber(total)+'</td><td>'+esc(x.reference_number||'-')+'</td><td>'+(isLocked?'<strong>Terkunci</strong>':'<button type="button" data-edit-bl="'+esc(x.id)+'">Edit</button> <button type="button" data-delete-bl="'+esc(x.id)+'">Hapus</button>')+'</td></tr>';
    }).join('')+
    '</tbody></table></div>'+(!txnMeat.total?'<p>Data Tambah Daging tidak ditemukan.</p>':'')+txnMeat.pager+'</section>';

  layout(html);
  [sr,pr,br,ar,cr].forEach(x=>{if(x.error)msg(x.error.message)});
  bindNumberInputs();
  bindTxnList(txnMeat,()=>marketingExternalMeatPage());

  const meatBarnSearch=document.getElementById('meatBarnSearch');
  const meatBarnId=document.getElementById('meatBarnId');
  const meatBarnSuggestions=document.getElementById('meatBarnSuggestions');
  if(meatBarnSearch&&meatBarnId&&meatBarnSuggestions){
    meatBarnSearch.oninput=()=>{
      const q=(meatBarnSearch.value||'').trim().toLowerCase();
      meatBarnId.value='';
      const rows=q?allowedBarns.filter(b=>{
        const a=activeByBarn.get(b.id),k=contractsRows.find(x=>x.id===a?.master_contract_id);
        return [b.code,b.name,shortContractLabel(k?.number),a?.start_date].filter(Boolean).join(' ').toLowerCase().includes(q);
      }).slice(0,5):[];
      meatBarnSuggestions.innerHTML=rows.map(b=>{
        const a=activeByBarn.get(b.id),k=contractsRows.find(x=>x.id===a?.master_contract_id);
        return '<button type="button" class="search-suggestion" data-meat-barn="'+esc(b.id)+'"><strong>'+esc(shortBarnLabel(b))+'</strong><small>'+esc([shortContractLabel(k?.number),a?.start_date].filter(Boolean).join(' · '))+'</small></button>';
      }).join('');
      if(q&&!rows.length)meatBarnSuggestions.innerHTML='<div class="search-empty">Kandang aktif tidak ditemukan.</div>';
      meatBarnSuggestions.querySelectorAll('[data-meat-barn]').forEach(btn=>btn.onclick=()=>{
        const b=allowedBarns.find(x=>x.id===btn.dataset.meatBarn);if(!b)return;
        meatBarnId.value=b.id;meatBarnSearch.value=shortBarnLabel(b);meatBarnSuggestions.innerHTML='';
      });
    };
  }

  const form=document.getElementById('externalMeatForm'),weight=document.getElementById('meatWeight'),price=document.getElementById('meatPrice'),total=document.getElementById('meatTotal');
  const calc=()=>{const w=normalizeInputID(weight.value)||0,p=normalizeInputID(price.value)||0;total.value=w&&p?'Rp '+fmtNumber(w*p):'';};
  weight.addEventListener('input',calc);price.addEventListener('input',calc);calc();

  form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form),barnId=fd.get('barn_id'),assignment=activeByBarn.get(barnId);
    if(!assignment)return msg('Kandang belum memiliki kontrak Logistik aktif.');
    const w=normalizeInputID(fd.get('weight_kg')),p=normalizeInputID(fd.get('purchase_price_per_kg'));
    if(!(w>0))return msg('Berat harus lebih dari 0 Kg.');
    if(p===null||p<0)return msg('Harga beli tidak valid.');
    const payload={contract_assignment_id:assignment.id,barn_id:barnId,supplier_id:fd.get('supplier_id'),purchase_date:fd.get('purchase_date'),product_name:fd.get('product_name'),weight_kg:w,purchase_price_per_kg:p,reference_number:fd.get('reference_number')||null,notes:fd.get('notes')||null};
    const id=fd.get('id');
    const q=id?db.from('marketing_external_meat_purchases').update(payload).eq('id',id):db.from('marketing_external_meat_purchases').insert(payload);
    const {error}=await q;
    if(error)return msg(error.message);
    await marketingExternalMeatPage();
    msg(id?'Tambah Daging berhasil diperbarui.':'Tambah Daging berhasil disimpan dan terkait ke RHPP kandang.',true);
  };

  document.querySelectorAll('[data-edit-bl]').forEach(btn=>btn.onclick=()=>marketingExternalMeatPage(btn.dataset.editBl));
  document.querySelectorAll('[data-delete-bl]').forEach(btn=>btn.onclick=async()=>{
    if(!confirm('Hapus data Tambah Daging ini?'))return;
    const {error}=await db.from('marketing_external_meat_purchases').delete().eq('id',btn.dataset.deleteBl);
    if(error)return msg(error.message);
    await marketingExternalMeatPage();
    msg('Tambah Daging berhasil dihapus.',true);
  });
  const cancel=document.getElementById('cancelBlEdit');if(cancel)cancel.onclick=()=>marketingExternalMeatPage();
}
async function logisticsExternalReturnPage(editId=null){
  const [br,ar,ir,sr,supr,er,rr,rir,tr]=await Promise.all([
    db.from('barns').select('id,code,name,location,active').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,active').order('created_at',{ascending:false}),
    db.from('items').select('id,code,name,unit,kg_per_unit,active').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_external_shipments').select('*').order('shipment_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('suppliers').select('id,code,name').eq('supplier_type','SAPRONAK').order('code',{ascending:true}),
    db.from('logistics_external_shipment_items').select('*').order('created_at',{ascending:false}),
    db.from('logistics_external_returns').select('*').order('return_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('logistics_external_return_items').select('*').order('created_at',{ascending:false}),
    db.from('logistics_external_return_transfers').select('*').order('created_at',{ascending:false})
  ]);
  const barns=br.data||[],assignments=ar.data||[],items=ir.data||[],heads=sr.data||[],suppliers=supr.data||[],details=er.data||[],returns=rr.data||[],returnItems=rir.data||[],transfers=tr.data||[];
  const activeAssignments=assignments.filter(a=>a.active),activeByBarn=new Map(activeAssignments.map(a=>[a.barn_id,a]));
  const selected=editId?returns.find(r=>r.id===editId):null;
  const selectedItem=selected?returnItems.find(x=>x.external_return_id===selected.id):null;
  const sourceById=new Map(details.map(x=>[x.id,x]));
  const headById=new Map(heads.map(x=>[x.id,x]));
  const usedQty=(sourceItemId,excludeReturnId=null)=>returnItems.reduce((n,x)=>{
    if(x.external_shipment_item_id!==sourceItemId)return n;
    if(excludeReturnId&&x.external_return_id===excludeReturnId)return n;
    return n+prodNum(x.quantity);
  },0);
  const remaining=(d,excludeReturnId=null)=>Math.max(0,prodNum(d.quantity)-usedQty(d.id,excludeReturnId));
  const transferredQty=returnItemId=>transfers.reduce((n,t)=>n+(t.external_return_item_id===returnItemId?prodNum(t.quantity):0),0);
  const transferableQty=ri=>Math.max(0,prodNum(ri?.quantity)-transferredQty(ri?.id));
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  let html='<section class="panel"><h3>Retur Tambah Sapronak</h3>'+
    '<p class="muted">Retur pembelian luar disimpan sebagai Draft terlebih dahulu. Draft menjadi stok retur dan belum memindahkan biaya ke kandang lain. Biaya baru berpindah dari siklus asal ke siklus tujuan saat tombol Kirim digunakan; Arus Kas perusahaan tidak berubah.</p>'+
    '<form id="extReturnForm" class="return-form"><div class="return-grid">'+
      '<label>Cari / Pilih Kandang<input id="extReturnBarnSearch" autocomplete="off" placeholder="Contoh: cicurug" value="'+(selected?esc(shortBarnLabel(barns.find(b=>b.id===selected.barn_id))):'')+'" required></label>'+
      '<input type="hidden" id="extReturnBarnId" value="'+esc(selected?.barn_id||'')+'">'+
      '<label>Tanggal Retur<input type="date" id="extReturnDate" value="'+esc(selected?.return_date||today)+'" required></label>'+
      '<div id="extReturnBarnSuggestions" class="search-suggestions return-span-2"></div>'+
      '<label class="return-span-2">Cari Pembelian Luar<input id="extReturnItemSearch" autocomplete="off" placeholder="Ketik kode / nama sapronak"></label>'+
      '<input type="hidden" id="extReturnSourceItem" value="'+esc(selectedItem?.external_shipment_item_id||'')+'">'+
      '<div id="extReturnItemSuggestions" class="search-suggestions return-span-2"></div>'+
      '<label>Jumlah Retur<input id="extReturnQty" data-number="1" inputmode="decimal" value="'+(selectedItem?fmtNumber(selectedItem.quantity):'')+'" required></label>'+
      '<label>Referensi<input id="extReturnRef" value="'+esc(selected?.reference||'')+'" placeholder="Opsional"></label>'+
      '<label class="return-span-2">Catatan<input id="extReturnNotes" value="'+esc(selected?.notes||'')+'" placeholder="Opsional"></label>'+
    '</div>'+
    '<p id="extReturnInfo" class="muted compact-note"></p>'+
    '<div class="inline-actions"><button type="submit">'+(selected?'Simpan Perubahan Draft':'Simpan Draft')+'</button>'+
      (selected?'<button type="button" id="cancelExtReturn">Batal</button>':'')+
    '</div></form></section>'+
    '<section class="panel" id="extTransferPanel" style="display:none"><h3>Kirim Stok Retur ke Kandang Lain</h3>'+
      '<input type="hidden" id="extTransferReturnItem">'+
      '<p id="extTransferSourceInfo" class="muted"></p>'+
      '<div class="return-grid">'+
        '<label>Cari Kandang Tujuan<input id="extTransferBarnSearch" autocomplete="off" placeholder="Ketik nama kandang aktif"></label>'+
        '<input type="hidden" id="extTransferAssignment">'+
        '<label>Jumlah Kirim<input id="extTransferQty" data-number="1" inputmode="decimal" placeholder="Jumlah"></label>'+
        '<div id="extTransferBarnSuggestions" class="search-suggestions return-span-2"></div>'+
        '<label>Tanggal Kirim<input type="date" id="extTransferDate" value="'+today+'"></label>'+
        '<label>Catatan<input id="extTransferNotes" placeholder="Opsional"></label>'+
      '</div>'+
      '<div class="inline-actions"><button type="button" id="saveExtTransfer">Kirim</button><button type="button" id="cancelExtTransfer">Batal</button></div>'+
    '</section>';

  const draftReturns=returns.filter(r=>{
    const ri=returnItems.find(x=>x.external_return_id===r.id);
    return ri&&transferableQty(ri)>0;
  });
  const sentRows=transfers.map(t=>{
    const ri=returnItems.find(x=>x.id===t.external_return_item_id),r=returns.find(x=>x.id===ri?.external_return_id),it=items.find(x=>x.id===t.item_id),src=barns.find(x=>x.id===t.source_barn_id),dst=barns.find(x=>x.id===t.target_barn_id);
    return {t,ri,r,it,src,dst};
  });

  html+='<section class="panel"><h3>Stok Retur / Draft</h3><p class="muted">Barang di bagian ini belum seluruhnya dikirim ke kandang tujuan.</p><div class="tablewrap compact-table"><table><thead><tr>'+
    '<th>Tanggal</th><th>Kandang Asal</th><th>Supplier</th><th>Sapronak</th><th>Jumlah Retur</th><th>Sisa Draft</th><th>Satuan</th><th>Status</th><th>Aksi</th>'+
    '</tr></thead><tbody>'+
    draftReturns.map(r=>{
      const ri=returnItems.find(x=>x.external_return_id===r.id),it=items.find(x=>x.id===ri?.item_id),sup=suppliers.find(x=>x.id===r.supplier_id),b=barns.find(x=>x.id===r.barn_id),a=assignments.find(x=>x.id===r.contract_assignment_id);
      const leftTransfer=transferableQty(ri);
      const hasOtherActive=activeAssignments.some(x=>x.barn_id!==r.barn_id);
      const sendButton=hasOtherActive
        ?'<button type="button" class="btn-secondary" data-transfer-ext-return="'+esc(ri.id)+'">Kirim</button>'
        :'<button type="button" class="btn-secondary" disabled title="Belum ada kandang aktif lain">Kirim</button>';
      const canEdit=a?.active&&r.status==='DRAFT'&&transferredQty(ri.id)<=0;
      const statusLabel=r.status==='PARTIAL'?'PARSIAL':'DRAFT';
      return '<tr><td>'+esc(r.return_date||'-')+'</td><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td>'+esc(sup?.name||'-')+'</td><td>'+esc(it?it.code+' · '+it.name:'-')+'</td><td>'+fmtNumber(ri?.quantity)+'</td><td><strong>'+fmtNumber(leftTransfer)+'</strong></td><td>'+esc(it?.unit||'-')+'</td><td><span class="pill">'+statusLabel+'</span></td><td>'+sendButton+' '+(canEdit?'<button type="button" data-edit-ext-return="'+esc(r.id)+'">Edit Draft</button> <button type="button" data-delete-ext-return="'+esc(r.id)+'">Hapus Draft</button>':'')+'</td></tr>';
    }).join('')+
    '</tbody></table></div>'+(!draftReturns.length?'<p>Tidak ada stok retur yang menunggu dikirim.</p>':'')+'</section>'+
    '<section class="panel"><h3>Riwayat Pengiriman Stok Retur</h3><div class="tablewrap compact-table"><table><thead><tr><th>Tanggal</th><th>Dari</th><th>Ke</th><th>Sapronak</th><th>Jumlah</th><th>Satuan</th><th>Status</th></tr></thead><tbody>'+
    sentRows.map(x=>'<tr><td>'+esc(x.t.transferred_on||'-')+'</td><td>'+esc(x.src?shortBarnLabel(x.src):'-')+'</td><td>'+esc(x.dst?shortBarnLabel(x.dst):'-')+'</td><td>'+esc(x.it?x.it.code+' · '+x.it.name:'-')+'</td><td>'+fmtNumber(x.t.quantity)+'</td><td>'+esc(x.it?.unit||'-')+'</td><td><span class="pill">TERKIRIM</span></td></tr>').join('')+
    '</tbody></table></div>'+(!sentRows.length?'<p>Belum ada pengiriman stok retur.</p>':'')+'</section>';

  layout(html);
  bindNumberInputs();
  const err=[br,ar,ir,sr,supr,er,rr,rir,tr].find(x=>x?.error)?.error;if(err)msg(err.message);

  const barnSearch=document.getElementById('extReturnBarnSearch'),barnId=document.getElementById('extReturnBarnId'),barnSugs=document.getElementById('extReturnBarnSuggestions');
  const itemSearch=document.getElementById('extReturnItemSearch'),sourceInput=document.getElementById('extReturnSourceItem'),itemSugs=document.getElementById('extReturnItemSuggestions'),info=document.getElementById('extReturnInfo');
  const availableBarns=barns.filter(b=>activeByBarn.has(b.id));
  const currentAssignment=()=>activeByBarn.get(barnId.value);
  const currentSource=()=>sourceById.get(sourceInput.value);

  const setInfo=()=>{
    const d=currentSource();if(!d){info.textContent='';return}
    const h=headById.get(d.external_shipment_id),it=items.find(x=>x.id===d.item_id),sup=suppliers.find(x=>x.id===h?.supplier_id),left=remaining(d,selected?.id||null);
    info.textContent='Pembelian '+(h?.shipment_date||'-')+' · '+(sup?.name||'-')+' · Sisa bisa diretur '+prodFmt(left,2)+' '+(it?.unit||'Satuan')+' · Harga beli Rp '+prodFmt(d.purchase_unit_price,0);
  };

  const renderBarn=()=>{
    const q=(barnSearch.value||'').trim().toLowerCase();
    if(!q){barnSugs.innerHTML='';return}
    barnId.value='';
    const rows=availableBarns.filter(b=>[b.code,b.name,b.location].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5);
    barnSugs.innerHTML=rows.map(b=>'<button type="button" class="search-suggestion" data-ext-barn="'+esc(b.id)+'"><strong>'+esc(b.code+' · '+b.name)+'</strong></button>').join('');
    if(!rows.length)barnSugs.innerHTML='<div class="search-empty">Kandang aktif tidak ditemukan.</div>';
    barnSugs.querySelectorAll('[data-ext-barn]').forEach(btn=>btn.onclick=()=>{const b=availableBarns.find(x=>x.id===btn.dataset.extBarn);barnId.value=b.id;barnSearch.value=shortBarnLabel(b);barnSugs.innerHTML='';sourceInput.value='';itemSearch.value='';itemSugs.innerHTML='';setInfo()});
  };
  barnSearch.oninput=renderBarn;

  const renderItems=()=>{
    const q=(itemSearch.value||'').trim().toLowerCase(),a=currentAssignment();
    sourceInput.value='';
    if(!q){itemSugs.innerHTML='';setInfo();return}
    if(!a){itemSugs.innerHTML='<div class="search-empty">Pilih kandang terlebih dahulu.</div>';return}
    const rows=details.filter(d=>{
      const h=headById.get(d.external_shipment_id),it=items.find(x=>x.id===d.item_id);
      return h?.contract_assignment_id===a.id&&remaining(d,selected?.id||null)>0&&[it?.code,it?.name,h?.shipment_date].filter(Boolean).join(' ').toLowerCase().includes(q);
    }).slice(0,5);
    itemSugs.innerHTML=rows.map(d=>{const h=headById.get(d.external_shipment_id),it=items.find(x=>x.id===d.item_id),sup=suppliers.find(x=>x.id===h?.supplier_id);return '<button type="button" class="search-suggestion" data-ext-source="'+esc(d.id)+'"><strong>'+esc((it?.code||'')+' · '+(it?.name||''))+'</strong><small>'+esc((h?.shipment_date||'-')+' · '+(sup?.name||'-')+' · Sisa '+prodFmt(remaining(d,selected?.id||null),2)+' '+(it?.unit||''))+'</small></button>'}).join('');
    if(!rows.length)itemSugs.innerHTML='<div class="search-empty">Pembelian luar tidak ditemukan / sudah habis diretur.</div>';
    itemSugs.querySelectorAll('[data-ext-source]').forEach(btn=>btn.onclick=()=>{const d=sourceById.get(btn.dataset.extSource),it=items.find(x=>x.id===d?.item_id);sourceInput.value=d.id;itemSearch.value=(it?.code||'')+' · '+(it?.name||'');itemSugs.innerHTML='';setInfo()});
    setInfo();
  };
  itemSearch.oninput=renderItems;

  if(selectedItem){
    const d=sourceById.get(selectedItem.external_shipment_item_id),it=items.find(x=>x.id===d?.item_id);
    if(it)itemSearch.value=it.code+' · '+it.name;
    setInfo();
  }

  document.getElementById('extReturnForm').onsubmit=async e=>{
    e.preventDefault();
    const d=currentSource(),qty=normalizeInputID(document.getElementById('extReturnQty').value);
    if(!barnId.value||!currentAssignment())return msg('Pilih kandang aktif.');
    if(!d)return msg('Pilih pembelian Tambah Sapronak yang akan diretur.');
    if(!(qty>0))return msg('Jumlah retur harus lebih dari 0.');
    const max=remaining(d,selected?.id||null);if(qty>max)return msg('Jumlah retur melebihi sisa. Maksimal '+prodFmt(max,2)+'.');
    const {error}=await db.rpc('save_external_sapronak_return_atomic',{
      p_id:selected?.id||null,p_external_shipment_item_id:d.id,p_return_date:document.getElementById('extReturnDate').value,
      p_reference:document.getElementById('extReturnRef').value||null,p_notes:document.getElementById('extReturnNotes').value||null,p_quantity:qty
    });
    if(error)return msg(error.message);
    await logisticsExternalReturnPage();
    msg(selected?'Draft retur diperbarui.':'Draft retur tersimpan dan masuk Stok Retur.',true);
  };
  const transferPanel=document.getElementById('extTransferPanel');
  const transferReturnItem=document.getElementById('extTransferReturnItem');
  const transferSourceInfo=document.getElementById('extTransferSourceInfo');
  const transferBarnSearch=document.getElementById('extTransferBarnSearch');
  const transferAssignment=document.getElementById('extTransferAssignment');
  const transferBarnSugs=document.getElementById('extTransferBarnSuggestions');
  const transferQty=document.getElementById('extTransferQty');

  root.querySelectorAll('[data-transfer-ext-return]').forEach(btn=>btn.onclick=()=>{
    const ri=returnItems.find(x=>x.id===btn.dataset.transferExtReturn);
    const erow=returns.find(x=>x.id===ri?.external_return_id);
    const it=items.find(x=>x.id===ri?.item_id);
    if(!ri||!erow)return;
    transferReturnItem.value=ri.id;
    transferAssignment.value='';
    transferBarnSearch.value='';
    transferQty.value='';
    transferBarnSugs.innerHTML='';
    const left=transferableQty(ri);
    transferSourceInfo.textContent=(it?.code||'')+' · '+(it?.name||'')+' · Stok draft tersedia '+prodFmt(left,2)+' '+(it?.unit||'');
    transferPanel.style.display='';
    transferPanel.scrollIntoView({behavior:'smooth',block:'start'});
  });

  if(transferBarnSearch){
    transferBarnSearch.oninput=()=>{
      const sourceRi=returnItems.find(x=>x.id===transferReturnItem.value);
      const sourceReturn=returns.find(x=>x.id===sourceRi?.external_return_id);
      const q=(transferBarnSearch.value||'').trim().toLowerCase();
      transferAssignment.value='';
      if(!q){transferBarnSugs.innerHTML='';return}
      const rows=activeAssignments.filter(a=>a.barn_id!==sourceReturn?.barn_id).map(a=>({a,b:barns.find(x=>x.id===a.barn_id)})).filter(x=>x.b&&[x.b.code,x.b.name,x.b.location].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5);
      transferBarnSugs.innerHTML=rows.map(x=>'<button type="button" class="search-suggestion" data-transfer-assignment="'+esc(x.a.id)+'"><strong>'+esc(shortBarnLabel(x.b))+'</strong></button>').join('');
      if(!rows.length)transferBarnSugs.innerHTML='<div class="search-empty">Kandang aktif lain tidak ditemukan.</div>';
      transferBarnSugs.querySelectorAll('[data-transfer-assignment]').forEach(b=>b.onclick=()=>{
        const a=activeAssignments.find(x=>x.id===b.dataset.transferAssignment),barn=barns.find(x=>x.id===a?.barn_id);
        if(!a||!barn)return;
        transferAssignment.value=a.id;
        transferBarnSearch.value=shortBarnLabel(barn);
        transferBarnSugs.innerHTML='';
      });
    };
  }

  const cancelTransfer=document.getElementById('cancelExtTransfer');
  if(cancelTransfer)cancelTransfer.onclick=()=>{transferPanel.style.display='none';};

  const saveTransfer=document.getElementById('saveExtTransfer');
  if(saveTransfer)saveTransfer.onclick=async()=>{
    const ri=returnItems.find(x=>x.id===transferReturnItem.value);
    const qty=normalizeInputID(transferQty.value);
    if(!ri)return msg('Pilih stok retur yang akan dikirim.');
    if(!transferAssignment.value)return msg('Pilih kandang tujuan aktif.');
    if(!(qty>0))return msg('Jumlah kirim harus lebih dari 0.');
    const max=transferableQty(ri);
    if(qty>max)return msg('Jumlah kirim melebihi stok draft. Maksimal '+prodFmt(max,2)+'.');
    const {error}=await db.rpc('transfer_external_sapronak_return_atomic',{
      p_external_return_item_id:ri.id,
      p_target_assignment_id:transferAssignment.value,
      p_quantity:qty,
      p_transferred_on:document.getElementById('extTransferDate').value,
      p_notes:document.getElementById('extTransferNotes').value||null
    });
    if(error)return msg(error.message);
    await logisticsExternalReturnPage();
    msg('Stok retur berhasil dikirim ke kandang tujuan.',true);
  };

  root.querySelectorAll('[data-edit-ext-return]').forEach(btn=>btn.onclick=()=>logisticsExternalReturnPage(btn.dataset.editExtReturn));
  root.querySelectorAll('[data-delete-ext-return]').forEach(btn=>btn.onclick=async()=>{if(!confirm('Hapus Draft Retur ini?'))return;const {error}=await db.from('logistics_external_returns').delete().eq('id',btn.dataset.deleteExtReturn);if(error)return msg(error.message);await logisticsExternalReturnPage();msg('Draft retur dihapus.',true)});
  const cancel=document.getElementById('cancelExtReturn');if(cancel)cancel.onclick=()=>logisticsExternalReturnPage();
}

async function logisticsReturnPage(editId=null){
  const [br,ir,rr,rir,ar,kr]=await Promise.all([
    db.from('barns').select('id,code,name,location,kind,active').eq('active',true).order('code',{ascending:true}),
    db.from('items').select('id,code,name,category,unit,kg_per_unit,active').eq('active',true).order('code',{ascending:true}),
    db.from('logistics_returns').select('*').order('return_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('logistics_return_items').select('*').order('created_at',{ascending:false}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,performance_template_name,active,created_at').order('created_at',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null)
  ]);

  const barns=br.data||[], itemsAll=ir.data||[], returns=rr.data||[], returnItems=rir.data||[], assignments=ar.data||[], masters=kr.data||[];
  const txnReturn=txnListState(returns,'logisticsReturn','return_date',5,barns),shownReturns=txnReturn.rows;
  const activeAssignments=assignments.filter(a=>a.active);
  const activeByBarn=new Map(activeAssignments.map(a=>[a.barn_id,a]));
  const selectableBarns=barns.filter(b=>activeByBarn.has(b.id));
  const selected=editId?returns.find(x=>x.id===editId):null;
  const selectedAssignment=selected?assignments.find(a=>a.id===selected.contract_assignment_id):null;
  const locked=selected?selectedAssignment?.active===false:false;
  let draftItems=selected?returnItems.filter(x=>x.return_id===selected.id).map(x=>({item_id:x.item_id,quantity:x.quantity,id:x.id})):[];
  window.__logisticsReturnDraftItems=draftItems;

  const todayID=()=>new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  let html='<section class="panel"><h3>Retur</h3>'+
    '<p class="muted">Retur mengikuti Kontrak Logistik aktif. Pilih kandang, tambahkan Sapronak yang diretur, lalu Simpan Draft. Harga Retur mengikuti harga kontrak.</p>'+
    '<form id="logisticsReturnForm" class="form-vertical">'+
      '<input type="hidden" name="return_id" value="'+(selected?esc(selected.id):'')+'">'+
      '<label>Cari / Pilih Kandang<input id="returnBarnSearch" autocomplete="off" placeholder="Contoh: cicurug" value="'+(selected?esc((barns.find(b=>b.id===selected.barn_id)?.code||'')+' · '+(barns.find(b=>b.id===selected.barn_id)?.name||'')):'')+'" '+(locked?'disabled':'')+' required></label>'+
      '<input type="hidden" name="barn_id" id="returnBarnId" value="'+(selected?esc(selected.barn_id):'')+'">'+
      '<div id="returnBarnSuggestions" class="search-suggestions"></div>'+
      '<label>Tanggal Retur<input type="date" name="return_date" value="'+esc(selected?.return_date||todayID())+'" '+(locked?'disabled':'')+' required></label>'+
      '<label>Referensi<input name="reference" value="'+esc(selected?.reference||'')+'" '+(locked?'disabled':'')+'></label>'+
      '<label>Catatan<textarea name="notes" '+(locked?'disabled':'')+'>'+esc(selected?.notes||'')+'</textarea></label>'+
    '</form>';

  if(!locked){
    html+='<div class="form-vertical compact-form">'+
      '<label>Cari / Pilih Sapronak<input id="returnItemSearch" autocomplete="off" placeholder="Ketik kode atau nama sapronak"></label>'+
      '<input type="hidden" id="returnItem">'+
      '<div id="returnItemSuggestions" class="search-suggestions"></div>'+
      '<label id="returnQtyLabel">Jumlah Retur<input id="returnQty" data-number="1" inputmode="decimal"></label>'+
      '<p id="returnQtyInfo" class="muted"></p>'+
      '<button type="button" id="addReturnItem">Tambah Retur</button>'+
    '</div>';
  }

  html+='<div class="tablewrap"><table><thead><tr><th>Kode</th><th>Sapronak</th><th>Jumlah</th><th>Satuan</th><th>Kg</th>'+(locked?'':'<th>Aksi</th>')+'</tr></thead><tbody id="returnDraftBody"></tbody></table></div>';
  if(locked) html+='<p><strong>Status: Terkunci</strong> — Kontrak Logistik periode ini sudah CLOSED.</p>';
  else{
    html+='<button type="button" id="saveReturnDraft">Simpan Draft</button>';
    if(selected) html+=' <button type="button" id="cancelReturnEdit">Batal Edit</button>';
  }
  html+='</section>';

  html+='<section class="panel"><h3>Riwayat Retur</h3>'+txnReturn.controls+'<div class="tablewrap"><table><thead><tr><th>Kandang</th><th>Tanggal</th><th>Referensi</th><th>Sapronak</th><th>Jumlah</th><th>Satuan</th><th>Kg</th><th>Harga/Satuan</th><th>Total</th><th>Status</th><th>Aksi</th></tr></thead><tbody>'+
    shownReturns.flatMap(r=>{
      const b=barns.find(x=>x.id===r.barn_id), a=assignments.find(x=>x.id===r.contract_assignment_id);
      const isLocked=a?.active===false;
      const details=returnItems.filter(x=>x.return_id===r.id);
      if(!details.length){
        return ['<tr><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td>'+esc(r.return_date||'-')+'</td><td>'+esc(r.reference||'-')+'</td><td>-</td><td>-</td><td>-</td><td>-</td><td>'+(isLocked?'Terkunci':'Draft')+'</td><td>'+(isLocked?'<button type="button" data-view-return="'+esc(r.id)+'">Lihat</button>':'<button type="button" data-view-return="'+esc(r.id)+'">Edit</button> <button type="button" data-delete-return="'+esc(r.id)+'">Hapus</button>')+'</td></tr>'];
      }
      return details.map((d,idx)=>{
        const i=itemsAll.find(x=>x.id===d.item_id);
        const kg=d.quantity_kg!=null?d.quantity_kg:(i?.category==='PAKAN'?Number(d.quantity)*Number(i.kg_per_unit||50):null);
        return '<tr><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td>'+esc(r.return_date||'-')+'</td><td>'+esc(r.reference||'-')+'</td><td>'+esc(i?.name||'-')+'</td><td>'+fmtNumber(d.quantity)+'</td><td>'+esc(i?.unit||'-')+'</td><td>'+fmtNumber(kg)+'</td><td>'+fmtNumber(d.unit_price)+'</td><td>'+fmtNumber(Number(d.quantity||0)*Number(d.unit_price||0))+'</td><td>'+(isLocked?'Terkunci':'Draft')+'</td><td>'+(idx===0?(isLocked?'<button type="button" data-view-return="'+esc(r.id)+'">Lihat</button>':'<button type="button" data-view-return="'+esc(r.id)+'">Edit</button> <button type="button" data-delete-return="'+esc(r.id)+'">Hapus</button>'):'')+'</td></tr>';
      });
    }).join('')+
    '</tbody></table></div>'+(!txnReturn.total?'<p>Data Retur tidak ditemukan.</p>':'')+txnReturn.pager+'<p class="muted">Riwayat lengkap tersedia di Laporan Logistik.</p></section>';

  layout(html);
  bindNumberInputs();
  bindTxnList(txnReturn,()=>logisticsReturnPage());

  const returnBarnSearch=document.getElementById('returnBarnSearch');
  const returnBarnId=document.getElementById('returnBarnId');
  const returnBarnSuggestions=document.getElementById('returnBarnSuggestions');
  if(returnBarnSearch&&returnBarnId&&returnBarnSuggestions&&!locked){
    const renderReturnBarnSuggestions=()=>{
      const q=(returnBarnSearch.value||'').trim().toLowerCase();
      returnBarnId.value='';
      const rows=q?selectableBarns.filter(x=>{
        const a=activeByBarn.get(x.id), k=masters.find(v=>v.id===a?.master_contract_id);
        const hay=[x.code,x.name,x.location,x.kind,'kontrak aktif',k?.number,a?.performance_template_name].filter(Boolean).join(' ').toLowerCase();
        return hay.includes(q);
      }).slice(0,5):[];
      returnBarnSuggestions.innerHTML=rows.map(x=>{
        const a=activeByBarn.get(x.id), k=masters.find(v=>v.id===a?.master_contract_id);
        return '<button type="button" class="search-suggestion" data-barn-id="'+esc(x.id)+'"><strong>'+esc(x.code+' · '+x.name)+'</strong><br><small>'+esc([x.location,k?.number,a?.performance_template_name].filter(Boolean).join(' · '))+'</small></button>';
      }).join('');
      if(q&&!rows.length)returnBarnSuggestions.innerHTML='<div class="search-empty">Kandang tidak ditemukan atau belum memiliki kontrak aktif.</div>';
      returnBarnSuggestions.querySelectorAll('[data-barn-id]').forEach(btn=>btn.onclick=()=>{
        const b=selectableBarns.find(x=>x.id===btn.dataset.barnId);
        if(!b)return;
        returnBarnSearch.value=shortBarnLabel(b);
        returnBarnId.value=b.id;
        returnBarnSuggestions.innerHTML='';
      });
    };
    returnBarnSearch.oninput=renderReturnBarnSuggestions;
    returnBarnSearch.onfocus=renderReturnBarnSuggestions;
  }

  const returnItem=document.getElementById('returnItem');
  const returnItemSearch=document.getElementById('returnItemSearch');
  const returnItemSuggestions=document.getElementById('returnItemSuggestions');
  const returnQty=document.getElementById('returnQty');
  const returnQtyLabel=document.getElementById('returnQtyLabel');
  const returnQtyInfo=document.getElementById('returnQtyInfo');
  const updateReturnQtyContext=()=>{
    if(!returnItem||!returnQtyLabel||!returnQtyInfo)return;
    const item=itemsAll.find(x=>x.id===returnItem.value);
    if(!item){
      returnQtyLabel.firstChild.textContent='Jumlah Retur';
      returnQtyInfo.textContent='';
      return;
    }
    returnQtyLabel.firstChild.textContent='Jumlah Retur ('+(item.unit||'-')+')';
    if(item.category==='PAKAN'){
      const kg=Number(item.kg_per_unit||50);
      returnQtyInfo.textContent='Pakan: 1 '+(item.unit||'ZAK')+' = '+fmtNumber(kg)+' kg. Total kg dihitung otomatis.';
    }else returnQtyInfo.textContent='Satuan retur: '+(item.unit||'-');
  };
  if(returnItemSearch&&returnItemSuggestions&&returnItem){
    const renderReturnItemSuggestions=()=>{
      const q=(returnItemSearch.value||'').trim().toLowerCase();
      returnItem.value='';
      const rows=q?itemsAll.filter(x=>[x.code,x.name,x.category,x.unit].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5):[];
      returnItemSuggestions.innerHTML=rows.map(x=>'<button type="button" class="search-suggestion" data-return-item="'+esc(x.id)+'"><strong>'+esc(x.code+' · '+x.name)+'</strong><br><small>'+esc([x.category,x.unit].filter(Boolean).join(' · '))+'</small></button>').join('');
      if(q&&!rows.length)returnItemSuggestions.innerHTML='<div class="search-empty">Sapronak tidak ditemukan.</div>';
      returnItemSuggestions.querySelectorAll('[data-return-item]').forEach(btn=>btn.onclick=()=>{
        const item=itemsAll.find(x=>x.id===btn.dataset.returnItem);
        if(!item)return;
        returnItem.value=item.id;
        returnItemSearch.value=item.code+' · '+item.name;
        returnItemSuggestions.innerHTML='';
        updateReturnQtyContext();
      });
      updateReturnQtyContext();
    };
    returnItemSearch.oninput=renderReturnItemSuggestions;
    returnItemSearch.onfocus=renderReturnItemSuggestions;
  }
  updateReturnQtyContext();

  const renderDraft=()=>{
    const body=document.getElementById('returnDraftBody'); if(!body)return;
    const arr=window.__logisticsReturnDraftItems||[];
    body.innerHTML=arr.map((x,idx)=>{
      const i=itemsAll.find(v=>v.id===x.item_id);
      const kg=i?.category==='PAKAN'?Number(x.quantity)*Number(i.kg_per_unit||50):null;
      return '<tr><td>'+esc(i?.code||'-')+'</td><td>'+esc(i?.name||'-')+'</td><td>'+fmtNumber(x.quantity)+'</td><td>'+esc(i?.unit||'-')+'</td><td>'+fmtNumber(kg)+'</td>'+
        (locked?'':'<td><button type="button" data-remove-return="'+idx+'">Hapus</button></td>')+'</tr>';
    }).join('');
    if(!locked) body.querySelectorAll('[data-remove-return]').forEach(btn=>btn.onclick=()=>{
      const arr=window.__logisticsReturnDraftItems||[];
      arr.splice(Number(btn.dataset.removeReturn),1);
      renderDraft();
    });
  };
  renderDraft();

  if(!locked){
    document.getElementById('addReturnItem').onclick=()=>{
      const itemId=returnItem.value;
      const qty=normalizeInputID(returnQty.value);
      if(!itemId||qty==null||qty<=0)return msg('Pilih Sapronak dan isi jumlah retur yang benar.');
      const arr=window.__logisticsReturnDraftItems||[];
      const exists=arr.find(x=>x.item_id===itemId);
      if(exists) exists.quantity=Number(exists.quantity)+Number(qty);
      else arr.push({item_id:itemId,quantity:qty});
      returnItem.value='';
      if(returnItemSearch)returnItemSearch.value='';
      if(returnItemSuggestions)returnItemSuggestions.innerHTML='';
      returnQty.value='';
      updateReturnQtyContext();
      renderDraft();
    };

    document.getElementById('saveReturnDraft').onclick=async()=>{
      const form=document.getElementById('logisticsReturnForm');
      const fd=new FormData(form);
      let barnId=String(fd.get('barn_id')||'');
      if(!barnId){
        const q=String(returnBarnSearch?.value||'').trim().toLowerCase();
        const matches=selectableBarns.filter(x=>[x.code,x.name,x.location].filter(Boolean).join(' ').toLowerCase().includes(q));
        if(matches.length===1)barnId=matches[0].id;
        else if(selectableBarns.length===1)barnId=selectableBarns[0].id;
      }
      const assignment=activeByBarn.get(barnId);
      const arr=window.__logisticsReturnDraftItems||[];
      if(!barnId)return msg('Pilih kandang dari daftar.');
      if(!assignment)return msg('Kandang belum memiliki kontrak Logistik aktif.');
      if(!arr.length)return msg('Tambahkan minimal satu Sapronak retur.');

      const returnId=fd.get('return_id')||null;
      const {error:saveError}=await db.rpc('save_logistics_return_atomic',{
        p_id:returnId,
        p_barn_id:barnId,
        p_assignment_id:assignment.id,
        p_return_date:fd.get('return_date'),
        p_reference:fd.get('reference')||null,
        p_notes:fd.get('notes')||null,
        p_items:arr.map(x=>({item_id:x.item_id,quantity:x.quantity}))
      });
      if(saveError)return msg(saveError.message);

      window.__logisticsReturnDraftItems=[];
      await logisticsReturnPage();
      msg(returnId?'Retur berhasil diperbarui.':'Draft retur tersimpan.',true);
    };
    if(selected) document.getElementById('cancelReturnEdit').onclick=()=>logisticsReturnPage();
  }

  root.querySelectorAll('[data-view-return]').forEach(btn=>btn.onclick=()=>logisticsReturnPage(btn.dataset.viewReturn));
  root.querySelectorAll('[data-delete-return]').forEach(btn=>btn.onclick=async()=>{
    if(!confirm('Hapus draft retur ini?'))return;
    const {error}=await db.from('logistics_returns').delete().eq('id',btn.dataset.deleteReturn);
    if(error)return msg(error.message);
    await logisticsReturnPage();
    msg('Draft retur dihapus.',true);
  });
  const err=br.error||ir.error||rr.error||rir.error||ar.error||kr.error;
  if(err)msg(err.message);
}

function attachListFilter({tableId,fields}){
  const table=document.getElementById(tableId);
  if(!table||table.dataset.filterReady==='1')return;
  table.dataset.filterReady='1';
  const wrap=table.closest('.tablewrap')||table;
  const form=document.createElement('form');
  form.className='form-vertical master-filter-form';
  form.innerHTML=fields.map((f,i)=>{
    const name='f'+i;
    if(f.type==='select'){
      return '<label>'+esc(f.label)+'<select name="'+name+'"><option value="">'+esc(f.allLabel||('Semua '+f.label))+'</option>'+(f.options||[]).map(v=>'<option value="'+esc(v)+'">'+esc(v)+'</option>').join('')+'</select></label>';
    }
    return '<label>'+esc(f.label)+'<input name="'+name+'" placeholder="'+esc(f.placeholder||'')+'"></label>';
  }).join('')+'<div class="report-actions"><button type="submit">Tampilkan</button><button type="button" data-list-filter-reset>Reset Filter</button></div>';
  wrap.parentNode.insertBefore(form,wrap);
  wrap.style.display='none';
  const rows=[...table.querySelectorAll('tbody tr')];
  form.onsubmit=ev=>{
    ev.preventDefault();
    const fd=new FormData(form);
    rows.forEach(row=>{
      const cells=[...row.cells];
      const ok=fields.every((f,i)=>{
        const q=String(fd.get('f'+i)||'').trim().toLowerCase();
        if(!q)return true;
        const txt=String(cells[f.col]?.textContent||'').trim().toLowerCase();
        return f.type==='select'?txt===q:txt.includes(q);
      });
      row.style.display=ok?'':'none';
    });
    wrap.style.display='';
  };
  form.querySelector('[data-list-filter-reset]').onclick=()=>{
    form.reset();
    rows.forEach(row=>row.style.display='');
    wrap.style.display='none';
  };
}

function logisticsMenuPage(kind){
  const map={
    logistik_retur:['Retur','Form dan daftar retur Logistik akan dibangun pada tahap berikutnya.']
  };
  const x=map[kind];
  layout('<section class="panel"><h3>'+x[0]+'</h3><p class="muted">'+x[1]+'</p></section>');
}

async function supplierMasterPage(type){
  const isMeat=type==='DAGING';
  const label=isMeat?'Supplier Daging':'Supplier Sapronak';
  const {data,error}=await db.from('suppliers').select('*').eq('supplier_type',type).order('code',{ascending:true});
  const rows=data||[];
  const html='<section class="panel"><h3>'+label+'</h3>'+
    '<form id="supplierTypedForm" class="form-vertical">'+
      '<input type="hidden" name="id">'+
      '<label>Nama Supplier<input name="name" required></label>'+
      '<label>Alamat<textarea name="address"></textarea></label>'+
      '<label>Telepon/WhatsApp<input name="phone"></label>'+
      '<label>Kontak Person<input name="contact_person"></label>'+
      '<label>Bank<input name="bank_name"></label>'+
      '<label>No. Rekening<input name="bank_account_number"></label>'+
      '<label>Atas Nama Rekening<input name="bank_account_name"></label>'+
      '<label>NPWP<input name="tax_number"></label>'+
      '<label>NIB/No. Usaha<input name="business_id"></label>'+
      '<label>Catatan<textarea name="notes"></textarea></label>'+
      '<button type="submit" id="supplierTypedSave">Simpan</button>'+
      '<button type="button" id="supplierTypedCancel" hidden>Batal Edit</button>'+
    '</form></section>'+
    '<section class="panel"><h3>Data '+label+'</h3><div class="tablewrap"><table id="supplierTypedTable"><thead><tr>'+
      '<th>Kode</th><th>Nama</th><th>Telepon</th><th>Kontak</th><th>Bank</th><th>Status</th><th>Aksi</th>'+
    '</tr></thead><tbody>'+
      rows.map(x=>'<tr><td>'+esc(x.code||'')+'</td><td>'+esc(x.name||'')+'</td><td>'+esc(x.phone||'-')+'</td><td>'+esc(x.contact_person||'-')+'</td><td>'+esc(x.bank_name||'-')+'</td><td>'+(x.active?'Aktif':'Nonaktif')+'</td><td><button type="button" data-edit-typed-supplier="'+esc(x.id)+'">Edit</button> <button type="button" data-toggle-typed-supplier="'+esc(x.id)+'">'+(x.active?'Nonaktifkan':'Aktifkan')+'</button></td></tr>').join('')+
    '</tbody></table></div>'+(!rows.length?'<p>Belum ada '+label+'.</p>':'')+'</section>';
  layout(html);
  attachListFilter({tableId:'supplierTypedTable',fields:[
    {label:'Kode',col:0,placeholder:'Kode supplier'},
    {label:'Nama',col:1,placeholder:'Nama supplier'},
    {label:'Telepon',col:2,placeholder:'Telepon'},
    {label:'Kontak',col:3,placeholder:'Kontak person'},
    {label:'Bank',col:4,placeholder:'Bank'},
    {label:'Status',col:5,type:'select',options:['Aktif','Nonaktif']}
  ]});
  if(error)msg(error.message);
  const form=document.getElementById('supplierTypedForm'),save=document.getElementById('supplierTypedSave'),cancel=document.getElementById('supplierTypedCancel');
  const reset=()=>{form.reset();form.elements.id.value='';save.textContent='Simpan';cancel.hidden=true;};
  cancel.onclick=reset;
  root.querySelectorAll('[data-edit-typed-supplier]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.id===btn.dataset.editTypedSupplier);if(!x)return;
    ['id','name','address','phone','contact_person','bank_name','bank_account_number','bank_account_name','tax_number','business_id','notes'].forEach(k=>{if(form.elements[k])form.elements[k].value=x[k]||'';});
    save.textContent='Simpan Perubahan';cancel.hidden=false;form.scrollIntoView({behavior:'smooth',block:'start'});
  });
  root.querySelectorAll('[data-toggle-typed-supplier]').forEach(btn=>btn.onclick=async()=>{
    const x=rows.find(v=>v.id===btn.dataset.toggleTypedSupplier);if(!x)return;
    const {error}=await db.from('suppliers').update({active:!x.active}).eq('id',x.id);
    if(error)return msg(error.message);
    await supplierMasterPage(type);msg(x.active?label+' dinonaktifkan.':label+' diaktifkan.',true);
  });
  form.onsubmit=async ev=>{
    ev.preventDefault();const fd=new FormData(form),id=fd.get('id');
    const payload={supplier_type:type,name:fd.get('name'),address:fd.get('address')||null,phone:fd.get('phone')||null,contact_person:fd.get('contact_person')||null,bank_name:fd.get('bank_name')||null,bank_account_number:fd.get('bank_account_number')||null,bank_account_name:fd.get('bank_account_name')||null,tax_number:fd.get('tax_number')||null,business_id:fd.get('business_id')||null,notes:fd.get('notes')||null};
    const q=id?db.from('suppliers').update(payload).eq('id',id):db.from('suppliers').insert(payload);
    const {error}=await q;if(error)return msg(error.message);
    await load();tab=isMeat?'supplier_daging':'supplier_sapronak';await supplierMasterPage(type);msg(id?label+' diperbarui.':label+' tersimpan.',true);
  };
}


const prodNum=v=>Number(v||0);
const prodFmt=(v,d=2)=>{const n=Number(v||0);const dec=d===0?0:2;return n.toLocaleString('id-ID',{minimumFractionDigits:dec,maximumFractionDigits:dec})};
const prodDateId=v=>{if(!v)return '-';const m=String(v).slice(0,10).match(/^(\d{4})-(\d{2})-(\d{2})$/);return m?m[3]+'/'+m[2]+'/'+m[1]:String(v)};
const prodToday=()=>new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());
const prodAge=(a,b)=>Math.max(1,Math.floor((new Date(b+'T00:00:00')-new Date(a+'T00:00:00'))/86400000)+1);
const prodDateAdd=(iso,days)=>{const d=new Date(String(iso).slice(0,10)+'T00:00:00');d.setDate(d.getDate()+Number(days||0));return d.toISOString().slice(0,10)};
async function productionBase(){
  const [ar,br,cr,cir,abr,er,ir,psr,mhr,lpr,costr]=await Promise.all([
    db.from('logistics_contract_assignments').select('id,barn_id,ppl_id,master_contract_id,performance_template_name,start_date,active,created_at').order('created_at',{ascending:false}),
    db.from('barns').select('id,code,name,active').order('code'),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('chick_ins').select('*').order('arrived_on',{ascending:false}),
    db.from('logistics_contract_assignment_abks').select('id,contract_assignment_id,abk_id,initial_birds,feed_pre_bags,feed_starter_bags,feed_finisher_bags,basics_locked_at'),
    db.from('employees').select('id,code,name,kind,active').eq('kind','ABK').order('code'),
    db.from('items').select('id,code,name,category,feed_phase,unit,kg_per_unit,active').eq('active',true).eq('category','PAKAN').order('code'),
    db.from('performance_standards').select('*'),
    db.from('marketing_contract_harvests').select('id,contract_assignment_id,harvested_on,birds,net_weight_kg,avg_weight_kg,total_amount'),
    db.from('contract_live_prices').select('contract_id,min_weight_kg,max_weight_kg,price_per_kg').order('min_weight_kg'),
    db.from('logistics_rhpp_cost_summary').select('contract_assignment_id,doc_cost,feed_cost,ovk_cost,net_sapronak_cost')
  ]);
  const err=[ar,br,cr,cir,abr,er,ir,psr,mhr,lpr,costr].find(x=>x.error)?.error;
  const allAssignments=ar.data||[];
  const assignments=profile?.role==='PPL'?allAssignments.filter(a=>a.ppl_id===session?.user?.id):allAssignments;
  const allowedIds=new Set(assignments.map(a=>a.id));
  const allowedBarnIds=new Set(assignments.map(a=>a.barn_id).filter(Boolean));
  const scoped=x=>profile?.role==='PPL'?(x||[]).filter(v=>allowedIds.has(v.contract_assignment_id)):(x||[]);
  const visibleBarns=profile?.role==='PPL'?(br.data||[]).filter(b=>allowedBarnIds.has(b.id)):(br.data||[]);
  return {err,assignments,barns:visibleBarns,masters:cr.data||[],chicks:scoped(cir.data),links:scoped(abr.data),abks:er.data||[],feedItems:ir.data||[],standards:psr.data||[],harvests:scoped(mhr.data),livePrices:lpr.data||[],rhppCosts:scoped(costr.data),scopeRows:scoped};
}
function prodAssignmentOption(d,a){
  return assignmentIdentity(d.assignments,d.barns,d.masters,a);
}
function prodActiveBarnOption(d,a){
  return assignmentActiveBarnLabel(d.barns,a);
}
function prodSelectAssignments(d,onlyActive=true){
  return d.assignments.filter(a=>!onlyActive||a.active).map(a=>'<option value="'+esc(a.id)+'">'+esc(onlyActive?prodActiveBarnOption(d,a):prodAssignmentOption(d,a))+'</option>').join('');
}
async function chickInPage(){
  const d=await productionBase();
  let html='<section class="panel"><h3>Chick-In / DOC Masuk</h3><form id="prodChick" class="form-vertical">'+
    '<label>Kandang Aktif<select name="assignment" required><option value="">Pilih</option>'+prodSelectAssignments(d,true)+'</select></label>'+
    '<input type="hidden" name="date" value="'+prodToday()+'">'+
    '<label>DOC In<input type="text" inputmode="numeric" data-number="1" name="received" required></label>'+
    '<label>DOC Mati Box<input type="text" inputmode="numeric" data-number="1" name="doa" value="0" required></label>'+
    '<label>Bobot Rata2<input type="text" inputmode="decimal" data-number="1" name="avg_weight"></label>'+
    '<label>Nomor DO<input name="delivery_number"></label>'+
    '<p id="prodChickNet" class="muted">Populasi awal bersih: 0 ekor</p>'+
    '<button>Simpan Chick-In</button></form></section>';
  html+='<section class="panel"><h3>Data Chick-In</h3><div class="tablewrap"><table><thead><tr><th>Kandang / Kontrak</th><th>DOC In</th><th>DOC Mati Box</th><th>Bobot Rata2</th><th>Nomor DO</th></tr></thead><tbody>'+
    d.chicks.filter(x=>x.contract_assignment_id).map(x=>{const a=d.assignments.find(a=>a.id===x.contract_assignment_id);return '<tr><td>'+esc(a?prodAssignmentOption(d,a):'-')+'</td><td>'+prodFmt(x.received,0)+'</td><td>'+prodFmt(x.doa,0)+'</td><td>'+prodFmt(x.avg_weight,2)+' g</td><td>'+esc(x.delivery_number||'-')+'</td></tr>'}).join('')+
    '</tbody></table></div></section>';
  layout(html); bindNumberInputs(); if(d.err)msg(d.err.message);
  const f=document.getElementById('prodChick'),net=document.getElementById('prodChickNet');
  const calc=()=>{
    f.received.value=formatInputID(f.received.value);
    f.doa.value=formatInputID(f.doa.value);
    if(f.avg_weight.value)f.avg_weight.value=formatInputID(f.avg_weight.value);
    net.textContent='Populasi awal bersih: '+Math.max(0,(normalizeInputID(f.received.value)||0)-(normalizeInputID(f.doa.value)||0)).toLocaleString('id-ID')+' ekor';
  };
  f.received.oninput=calc;f.doa.oninput=calc;f.avg_weight.oninput=calc;
  f.onsubmit=async e=>{e.preventDefault();const a=d.assignments.find(x=>x.id===f.assignment.value);if(!a)return msg('Pilih kontrak aktif dari Logistik.');
    const received=normalizeInputID(f.received.value);
    const doa=normalizeInputID(f.doa.value);
    const avgWeight=f.avg_weight.value?normalizeInputID(f.avg_weight.value):null;
    if(received===null||received<=0)return msg('Jumlah DOC Masuk harus lebih dari 0 ekor.');
    if(doa===null||doa<0)return msg('DOA harus 0 atau lebih.');
    if(doa>=received)return msg('DOA harus lebih kecil dari Jumlah DOC Masuk. Populasi awal bersih harus lebih dari 0 ekor.');
    const payload={contract_assignment_id:a.id,barn_id:a.barn_id,arrived_on:f.date.value,received,shipped:received,doa,strain:null,avg_weight:avgWeight,delivery_number:f.delivery_number.value||null};
    const existing=d.chicks.find(x=>x.contract_assignment_id===a.id);
    const q=existing?db.from('chick_ins').update(payload).eq('id',existing.id):db.from('chick_ins').insert(payload);
    const {error}=await q;if(error)return msg('Gagal menyimpan Chick-In: '+error.message);await chickInPage();msg('Chick-In tersimpan.',true);
  };
}
async function recordingPplPage(){
  const d=await productionBase();
  const [rr,sr]=await Promise.all([
    db.from('recordings').select('*').not('contract_assignment_id','is',null).order('recorded_on'),
    db.from('recording_weight_samples').select('*')
  ]);
  const recs=d.scopeRows(rr.data||[]),samples=sr.data||[];
  const txnRecording=txnListState(recs,'pplRecording','recorded_on',5,d.barns,'barn_id',{assignmentKey:'contract_assignment_id',assignments:d.assignments.map(a=>({id:a.id,barn_id:a.barn_id,label:assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED')}))});
  let html='<section class="panel"><h3>Recording PPL</h3><form id="prodRec" class="form-vertical">'+
    '<label>Kandang Aktif<select name="assignment" required><option value="">Pilih</option>'+d.assignments.filter(a=>a.active&&d.chicks.some(c=>c.contract_assignment_id===a.id)).map(a=>'<option value="'+esc(a.id)+'">'+esc(prodActiveBarnOption(d,a))+'</option>').join('')+'</select></label>'+
    '<p id="prodRecAge" class="muted"><strong>Hari ke-1</strong></p>'+
    '<label>Pakan Tersedia<select name="feed_item" required><option value="">Pilih Kandang / Kontrak dulu</option></select></label>'+
    '<p id="prodRecStock" class="muted">Sisa stok: -</p>'+
    '<label>Jumlah Pakan Dipakai (Zak/Satuan)<input type="number" name="feed_units" min="0" step="0.01" required></label>'+
    '<p id="prodRecKg" class="muted">Pemakaian: 0 Kg</p>'+
    '<label>Kematian (ekor)<input type="number" name="mortality" min="0" value="0" required></label>'+
    '<label>Pemusnahan / Afkir (ekor)<input type="number" name="culling" min="0" value="0" required></label>'+
    '<div><strong>Bobot Sampel per Ekor (Kg)</strong><p class="muted">Contoh: 0,85 Kg = 850 gram · 1,20 Kg = 1,2 Kg</p><div id="weightRows"></div><button type="button" id="addWeight">+ Tambah Sampel</button></div>'+
    '<label>Catatan<textarea name="notes"></textarea></label>'+
    '<label>Foto (opsional)<input type="file" name="photo" accept="image/*"></label>'+
    '<div class="inline-actions"><button id="prodRecSave">Simpan Recording</button><button type="button" id="prodRecCancel" style="display:none">Batal Edit</button></div></form></section>';

  const metricRows=[];
  for(const r of recs){
    const a=d.assignments.find(x=>x.id===r.contract_assignment_id),ci=d.chicks.find(x=>x.contract_assignment_id===r.contract_assignment_id);
    if(!a||!ci)continue;
    const prev=recs.filter(x=>x.contract_assignment_id===r.contract_assignment_id&&prodNum(x.age_days)<=prodNum(r.age_days));
    const cumDead=prev.reduce((s,x)=>s+prodNum(x.mortality)+prodNum(x.culling),0);
    const cumFeed=prev.reduce((s,x)=>s+prodNum(x.feed_kg),0);
    const initial=prodNum(ci.received)-prodNum(ci.doa);
    const population=Math.max(0,initial-cumDead);
    const ws=samples.filter(s=>s.recording_id===r.id).map(s=>prodNum(s.weight_g));
    const bwg=ws.length?ws.reduce((s,x)=>s+x,0)/ws.length:prodNum(r.avg_weight_kg)*1000;
    const bwkg=bwg/1000,biomass=population*bwkg;
    const fcr=biomass>0?cumFeed/biomass:0;
    const depl=initial>0?cumDead/initial*100:0;
    const age=prodNum(r.age_days);
    const ip=age>0&&fcr>0?((100-depl)*bwkg*100)/(age*fcr):0;
    const adg=age>0?(bwg-prodNum(ci.avg_weight))/age:0;
    const fi=initial>0?cumFeed*1000/initial:0;
    const st=d.standards.find(s=>s.contract_id===a.master_contract_id&&s.template_name===a.performance_template_name&&prodNum(s.age_days)===age);
    const stdFeedTotalKg=st?.std_feed_g_per_bird?prodNum(st.std_feed_g_per_bird)*initial/1000:null;
    metricRows.push({r,a,population,depl,bwg,cumFeed,fi,fcr,adg,ip,st,stdFeedTotalKg});
  }

  html+='<section class="panel"><h3>Performa Recording</h3>'+txnRecording.controls+'<div class="tablewrap"><table><thead><tr><th>Kandang</th><th>Hari</th><th>Populasi</th><th>Deplesi</th><th>BW Aktual / Standar</th><th>Pakan Aktual / Standar</th><th>Feed Intake</th><th>FCR</th><th>ADG</th><th>IP</th><th>Aksi</th></tr></thead><tbody id="prodPerfBody"></tbody></table></div>'+
    '<div class="inline-actions" style="margin-top:10px"><button type="button" id="prodPerfPrev">Sebelumnya</button><span id="prodPerfPage" class="muted"></span><button type="button" id="prodPerfNext">Berikutnya</button></div></section>';
  layout(html);
  if(d.err||rr.error||sr.error)msg((d.err||rr.error||sr.error).message);

  const allowedRecordingIds=new Set(txnRecording.rows.map(x=>x.id));
  const sortedRows=metricRows.filter(x=>allowedRecordingIds.has(x.r.id)).slice().sort((a,b)=>prodNum(b.r.age_days)-prodNum(a.r.age_days));
  const pageSize=5,totalPages=1;
  let page=1;
  const renderPerf=()=>{
    if(page>totalPages)page=totalPages;if(page<1)page=1;
    const rows=sortedRows.slice((page-1)*pageSize,page*pageSize);
    document.getElementById('prodPerfBody').innerHTML=rows.map(x=>
      '<tr><td>'+esc(prodAssignmentOption(d,x.a))+'</td><td>'+prodFmt(x.r.age_days,0)+'</td><td>'+prodFmt(x.population,0)+'</td><td>'+prodFmt(x.depl,2)+'%</td>'+
      '<td>'+prodFmt(x.bwg,0)+' / '+(x.st?.std_body_weight_g?prodFmt(x.st.std_body_weight_g,0):'-')+' g</td>'+
      '<td>'+prodFmt(x.cumFeed,2)+' / '+(x.stdFeedTotalKg!=null?prodFmt(x.stdFeedTotalKg,2):'-')+' Kg</td>'+
      '<td>'+prodFmt(x.fi,1)+' g/ekor</td><td>'+prodFmt(x.fcr,3)+'</td><td>'+prodFmt(x.adg,1)+' g</td><td>'+prodFmt(x.ip,1)+'</td>'+
      '<td><button type="button" data-edit-recording="'+esc(x.r.id)+'">Edit</button></td></tr>'
    ).join('');
    document.getElementById('prodPerfPage').textContent='Halaman '+(txnRecording.st.page+1)+' / '+txnRecording.pages+' · '+txnRecording.total+' data';
    document.getElementById('prodPerfPrev').disabled=txnRecording.st.page<=0;
    document.getElementById('prodPerfNext').disabled=txnRecording.st.page>=txnRecording.pages-1;
    document.querySelectorAll('[data-edit-recording]').forEach(b=>b.onclick=()=>startEdit(b.dataset.editRecording));
  };
  document.getElementById('prodPerfPrev').onclick=()=>{txnRecording.st.page=Math.max(0,txnRecording.st.page-1);recordingPplPage()};
  document.getElementById('prodPerfNext').onclick=()=>{txnRecording.st.page=Math.min(txnRecording.pages-1,txnRecording.st.page+1);recordingPplPage()};
  bindTxnList(txnRecording,()=>recordingPplPage());

  const f=document.getElementById('prodRec'),wr=document.getElementById('weightRows'),saveBtn=document.getElementById('prodRecSave'),cancelBtn=document.getElementById('prodRecCancel');
  let weights=[0],editingId=null,editingDay=null,feedStock=[];

  const syncWeightsFromDom=()=>{
    wr.querySelectorAll('[data-weight]').forEach(x=>{const i=Number(x.dataset.weight);if(weights[i]!=null)weights[i]=prodNum(x.value)});
  };
  const renderWeights=()=>{
    wr.innerHTML=weights.map((v,i)=>'<div class="inline-actions"><input type="number" min="0.01" step="0.01" data-weight="'+i+'" placeholder="Contoh: 0.85" value="'+(v||'')+'" required><span class="muted">Kg/ekor</span>'+(weights.length>1?'<button type="button" data-del-weight="'+i+'">Hapus</button>':'')+'</div>').join('');
    wr.querySelectorAll('[data-weight]').forEach(x=>x.oninput=()=>weights[Number(x.dataset.weight)]=prodNum(x.value));
    wr.querySelectorAll('[data-del-weight]').forEach(x=>x.onclick=()=>{syncWeightsFromDom();weights.splice(Number(x.dataset.delWeight),1);renderWeights()});
  };
  document.getElementById('addWeight').onclick=()=>{syncWeightsFromDom();weights.push(0);renderWeights()};
  renderWeights();

  const nextDayFor=assignmentId=>{
    const used=new Set(recs.filter(r=>r.contract_assignment_id===assignmentId).map(r=>prodNum(r.age_days)).filter(n=>n>=1));
    let day=1;while(used.has(day))day++;return day
  };
  let currentDay=1;

  const calc=()=>{
    currentDay=editingId?editingDay:(f.assignment.value?nextDayFor(f.assignment.value):1);
    document.getElementById('prodRecAge').innerHTML='<strong>Hari ke-'+currentDay+(editingId?' · Mode Edit':'')+'</strong>';
    const stock=feedStock.find(x=>x.item_id===f.feed_item.value);
    const used=prodNum(f.feed_units.value);
    document.getElementById('prodRecStock').textContent=stock?'Sisa stok tersedia: '+prodFmt(stock.remaining_units,2)+' '+(stock.unit||'Satuan')+' ('+prodFmt(stock.remaining_kg,2)+' Kg)':'Sisa stok: -';
    document.getElementById('prodRecKg').textContent='Pemakaian: '+prodFmt(used*prodNum(stock?.kg_per_unit),2)+' Kg';
  };

  const refreshFeedStock=async(selectedItem=null)=>{
    feedStock=[];
    f.feed_item.innerHTML='<option value="">Memuat pakan tersedia...</option>';
    document.getElementById('prodRecStock').textContent='Sisa stok: -';
    if(!f.assignment.value){f.feed_item.innerHTML='<option value="">Pilih Kandang / Kontrak dulu</option>';return}
    const {data,error}=await db.rpc('production_feed_stock',{p_contract_assignment_id:f.assignment.value});
    if(error){f.feed_item.innerHTML='<option value="">Gagal memuat stok</option>';return msg(error.message)}
    const editRec=editingId?recs.find(x=>x.id===editingId):null;
    feedStock=(data||[]).map(x=>{
      const y={...x};
      if(editRec&&editRec.contract_assignment_id===f.assignment.value&&editRec.feed_item_id===x.item_id){
        y.remaining_units=prodNum(y.remaining_units)+prodNum(editRec.feed_quantity_units);
        y.remaining_kg=prodNum(y.remaining_kg)+prodNum(editRec.feed_kg);
      }
      return y;
    }).filter(x=>prodNum(x.remaining_units)>0);
    f.feed_item.innerHTML='<option value="">Pilih Pakan</option>'+feedStock.map(x=>{
      const shortName=String(x.name||'').replace(/^Pakan\s+/i,'');
      return '<option value="'+esc(x.item_id)+'">'+esc(x.code+' · '+shortName+' · '+prodFmt(x.remaining_units,2)+' '+(x.unit||'Satuan')+' · '+prodFmt(x.remaining_kg,2)+' Kg')+'</option>'
    }).join('');
    if(!feedStock.length)f.feed_item.innerHTML='<option value="">Tidak ada stok pakan tersedia</option>';
    if(selectedItem)f.feed_item.value=selectedItem;
    calc();
  };

  const resetEdit=async()=>{
    editingId=null;editingDay=null;f.assignment.disabled=false;f.reset();weights=[0];renderWeights();
    saveBtn.textContent='Simpan Recording';cancelBtn.style.display='none';feedStock=[];
    f.feed_item.innerHTML='<option value="">Pilih Kandang / Kontrak dulu</option>';calc();
  };
  cancelBtn.onclick=resetEdit;

  async function startEdit(id){
    const r=recs.find(x=>x.id===id);if(!r)return;
    editingId=r.id;editingDay=prodNum(r.age_days);
    f.assignment.value=r.contract_assignment_id;f.assignment.disabled=true;
    f.mortality.value=prodNum(r.mortality);f.culling.value=prodNum(r.culling);
    f.feed_units.value=prodNum(r.feed_quantity_units);f.notes.value=r.notes||'';
    const ws=samples.filter(x=>x.recording_id===r.id).map(x=>prodNum(x.weight_g)/1000);
    weights=ws.length?ws:[prodNum(r.avg_weight_kg)];renderWeights();
    saveBtn.textContent='Update Recording';cancelBtn.style.display='';
    await refreshFeedStock(r.feed_item_id);
    window.scrollTo({top:0,behavior:'smooth'});
  }

  f.assignment.onchange=async()=>{calc();await refreshFeedStock()};
  f.feed_item.onchange=calc;f.feed_units.oninput=calc;calc();renderPerf();
  if(f.assignment.value)await refreshFeedStock();
  else {
    const eligible=d.assignments.filter(a=>a.active&&d.chicks.some(c=>c.contract_assignment_id===a.id));
    if(eligible.length===1){
      f.assignment.value=eligible[0].id;
      calc();
      await refreshFeedStock();
    }
  }

  f.onsubmit=async e=>{
    e.preventDefault();
    const a=d.assignments.find(x=>x.id===f.assignment.value),ci=a&&d.chicks.find(x=>x.contract_assignment_id===a.id),stock=feedStock.find(x=>x.item_id===f.feed_item.value);
    if(!a||!ci||!stock)return msg('Lengkapi kontrak, Chick-In dan pakan tersedia.');
    if(weights.some(x=>x<=0))return msg('Bobot sampel wajib diisi.');
    const feedUnits=prodNum(f.feed_units.value);
    if(feedUnits<=0)return msg('Jumlah pakan dipakai harus lebih dari 0.');
    if(feedUnits>prodNum(stock.remaining_units))return msg('Pemakaian melebihi sisa stok. Sisa '+prodFmt(stock.remaining_units,2)+' '+(stock.unit||'Satuan')+'.');
    currentDay=editingId?editingDay:nextDayFor(a.id);
    let photo=editingId?(recs.find(x=>x.id===editingId)?.photo_data||null):null;
    const file=f.photo.files?.[0];
    if(file){if(file.size>1024*1024)return msg('Foto maksimal 1 MB.');photo=await new Promise(res=>{const rd=new FileReader();rd.onload=()=>res(String(rd.result||''));rd.readAsDataURL(file)})}
    const avg=weights.reduce((s,x)=>s+x,0)/weights.length;
    const wasEdit=!!editingId;
    const {error:saveError}=await db.rpc('save_recording_atomic',{
      p_id:editingId||null,
      p_assignment_id:a.id,
      p_barn_id:a.barn_id,
      p_recorded_on:prodDateAdd(ci.arrived_on,currentDay-1),
      p_age_days:currentDay,
      p_mortality:Math.trunc(prodNum(f.mortality.value)),
      p_culling:Math.trunc(prodNum(f.culling.value)),
      p_feed_item_id:stock.item_id,
      p_feed_quantity_units:feedUnits,
      p_sample_count:weights.length,
      p_sample_weight_total_kg:weights.reduce((s,x)=>s+x,0),
      p_notes:f.notes.value||null,
      p_photo_data:photo,
      p_weights:weights.map(weight_kg=>({weight_g:weight_kg*1000}))
    });
    if(saveError)return msg(saveError.message);
    await recordingPplPage();msg(wasEdit?'Recording PPL berhasil diperbarui.':'Recording PPL tersimpan dan performa dihitung otomatis.',true);
  };
}
async function productionVisitPage(){
  const d=await productionBase();
  const vr=await db.from('visits').select('*').not('contract_assignment_id','is',null).order('visited_on',{ascending:false});
  const rows=d.scopeRows(vr.data||[]);
  const txnVisit=txnListState(rows,'pplVisit','visited_on',5,d.barns,'barn_id',{assignmentKey:'contract_assignment_id',assignments:d.assignments.map(a=>({id:a.id,barn_id:a.barn_id,label:assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED')})),statusKey:'follow_up_status',statusOptions:['BELUM','PROSES','SELESAI']}),shownVisits=txnVisit.rows;
  let html='<section class="panel"><h3>Kunjungan PPL</h3><form id="prodVisit" class="form-vertical">'+
    '<label>Kandang Aktif<select name="assignment" required><option value="">Pilih</option>'+prodSelectAssignments(d,true)+'</select></label>'+
    '<label>Tanggal Kunjungan<input type="date" name="date" value="'+prodToday()+'" required></label>'+
    '<label>Temuan<textarea name="findings" required></textarea></label>'+
    '<label>Tindakan / Rekomendasi<textarea name="recommendation" required></textarea></label>'+
    '<label>Tindak Lanjut<textarea name="follow_up" required></textarea></label>'+
    '<label>Status Tindak Lanjut<select name="follow_up_status" required><option value="BELUM">BELUM</option><option value="PROSES">PROSES</option><option value="SELESAI">SELESAI</option></select></label>'+
    '<label>Catatan<textarea name="notes"></textarea></label>'+
    '<div class="inline-actions"><button id="prodVisitSave">Simpan Kunjungan</button><button type="button" id="prodVisitCancel" style="display:none">Batal Edit</button></div>'+
    '</form></section>';
  html+='<section class="panel"><h3>Riwayat Kunjungan</h3>'+txnVisit.controls+'<div class="tablewrap"><table><thead><tr><th>Kandang</th><th>Tanggal</th><th>Temuan</th><th>Rekomendasi</th><th>Tindak Lanjut</th><th>Status</th><th>Catatan</th><th>Aksi</th></tr></thead><tbody>'+
    shownVisits.map(x=>{const a=d.assignments.find(a=>a.id===x.contract_assignment_id);return '<tr><td>'+esc(a?prodAssignmentOption(d,a):'-')+'</td><td>'+prodDateId(x.visited_on)+'</td><td>'+esc(x.findings||'-')+'</td><td>'+esc(x.recommendation||'-')+'</td><td>'+esc(x.follow_up||'-')+'</td><td>'+esc(x.follow_up_status||'-')+'</td><td>'+esc(x.notes||'-')+'</td><td><button type="button" data-edit-visit="'+esc(x.id)+'">Edit</button></td></tr>'}).join('')+
    '</tbody></table></div>'+(!txnVisit.total?'<p>Data Kunjungan tidak ditemukan.</p>':'')+txnVisit.pager+'</section>';
  layout(html);
  bindTxnList(txnVisit,()=>productionVisitPage());
  if(d.err||vr.error)msg((d.err||vr.error).message);

  const f=document.getElementById('prodVisit');
  const saveBtn=document.getElementById('prodVisitSave');
  const cancelBtn=document.getElementById('prodVisitCancel');
  let editingId=null;

  const reset=()=>{
    editingId=null;
    f.reset();
    f.date.value=prodToday();
    f.assignment.disabled=false;
    saveBtn.textContent='Simpan Kunjungan';
    cancelBtn.style.display='none';
  };
  cancelBtn.onclick=reset;

  root.querySelectorAll('[data-edit-visit]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.id===btn.dataset.editVisit);if(!x)return;
    editingId=x.id;
    f.assignment.value=x.contract_assignment_id||'';
    f.assignment.disabled=true;
    f.date.value=x.visited_on||prodToday();
    f.findings.value=x.findings||'';
    f.recommendation.value=x.recommendation||'';
    f.follow_up.value=x.follow_up||'';
    f.follow_up_status.value=x.follow_up_status||'BELUM';
    f.notes.value=x.notes||'';
    saveBtn.textContent='Update Kunjungan';
    cancelBtn.style.display='';
    window.scrollTo({top:0,behavior:'smooth'});
  });

  f.onsubmit=async e=>{
    e.preventDefault();
    const a=d.assignments.find(x=>x.id===f.assignment.value);
    if(!a)return msg('Pilih kontrak aktif.');
    const payload={
      contract_assignment_id:a.id,
      barn_id:a.barn_id,
      visited_on:f.date.value,
      findings:f.findings.value.trim()||null,
      recommendation:f.recommendation.value.trim()||null,
      follow_up:f.follow_up.value.trim()||null,
      follow_up_status:f.follow_up_status.value,
      notes:f.notes.value.trim()||null
    };
    const wasEdit=!!editingId;
    const q=editingId?db.from('visits').update(payload).eq('id',editingId):db.from('visits').insert(payload);
    const {error}=await q;
    if(error)return msg(error.message);
    await productionVisitPage();
    msg(wasEdit?'Kunjungan PPL berhasil diperbarui.':'Kunjungan PPL tersimpan.',true);
  };
}
async function productionEstimatePage(){
  const d=await productionBase();
  const [er,sr,rr]=await Promise.all([
    db.from('production_estimates').select('*').order('estimated_on',{ascending:false}),
    db.from('production_estimate_sizes').select('*'),
    db.from('recordings').select('*').not('contract_assignment_id','is',null)
  ]);
  const rows=d.scopeRows(er.data||[]),sizes=sr.data||[],recs=d.scopeRows(rr.data||[]);
  const txnEstimate=txnListState(rows,'pplEstimate','estimated_on',5,d.barns,'barn_id',{assignmentKey:'contract_assignment_id',assignments:d.assignments.map(a=>({id:a.id,barn_id:a.barn_id,label:assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED')}))}),pageRows=txnEstimate.rows;
  const eligibleAssignments=d.assignments.filter(a=>a.active&&d.chicks.some(c=>c.contract_assignment_id===a.id));

  const calcFinance=(a,ci,sz,estimatedOn)=>{
    const contract=d.masters.find(x=>x.id===a?.master_contract_id);
    let revenue=0,totalBirds=0,totalBiomass=0;
    for(const s of sz){
      const bw=prodNum(s.bw_kg),birds=prodNum(s.birds);
      const price=d.livePrices.find(p=>p.contract_id===a?.master_contract_id&&bw>=prodNum(p.min_weight_kg)&&(p.max_weight_kg==null||bw<prodNum(p.max_weight_kg)));
      revenue+=birds*bw*prodNum(price?.price_per_kg);
      totalBirds+=birds;
      totalBiomass+=birds*bw;
    }

    let preKg=0,starterKg=0,finisherKg=0,otherKg=0;
    recs.filter(r=>r.contract_assignment_id===a?.id&&(!estimatedOn||r.recorded_on<=estimatedOn)).forEach(r=>{
      const item=d.feedItems.find(i=>i.id===r.feed_item_id);
      const phase=String(item?.feed_phase||'').trim().toLowerCase();
      const kg=prodNum(r.feed_kg);
      if(phase.includes('pre'))preKg+=kg;
      else if(phase.includes('finish')||phase.includes('finis'))finisherKg+=kg;
      else if(phase.includes('starter'))starterKg+=kg;
      else otherKg+=kg;
    });

    const chickIn=prodNum(ci?.received);
    const docPrice=prodNum(contract?.doc_price);
    const prePrice=prodNum(contract?.pre_starter_price);
    const starterPrice=prodNum(contract?.starter_price);
    const finisherPrice=prodNum(contract?.finisher_price);
    const docCost=chickIn*docPrice;
    const preCost=preKg*prePrice;
    const starterCost=starterKg*starterPrice;
    const finisherCost=finisherKg*finisherPrice;
    const cost=docCost+preCost+starterCost+finisherCost;
    const profit=revenue-cost;
    const avgBw=totalBirds?totalBiomass/totalBirds:0;
    return {revenue,cost,profit,perChick:chickIn>0?profit/chickIn:0,avgBw,docCost,preKg,starterKg,finisherKg,otherKg,docPrice,prePrice,starterPrice,finisherPrice,preCost,starterCost,finisherCost};
  };

  let html='<section class="panel"><h3>Estimasi</h3><p class="muted">Mulai umur 23 hari. Satu umur/tanggal hanya boleh memiliki satu Estimasi. Gunakan Edit untuk memperbarui data yang sudah tersimpan.</p>'+
    '<form id="prodEst" class="form-vertical">'+
    '<label>Kandang Aktif<select name="assignment" required><option value="">Pilih</option>'+eligibleAssignments.map(a=>'<option value="'+esc(a.id)+'">'+esc(prodActiveBarnOption(d,a))+'</option>').join('')+'</select></label>'+
    '<input type="hidden" name="date">'+
    '<p id="estDate" class="muted">Tanggal Estimasi: -</p>'+
    '<p id="estAge" class="muted">Umur: -</p>'+
    '<p id="estActualHarvest" class="muted">Panen aktual Marketing: -</p>'+
    '<p id="estExisting" class="muted"></p>'+
    '<label>Sisa Ayam Real (ekor)<input type="number" min="0" name="remaining" readonly required></label>'+
    '<p id="estUnallocated" class="muted"><strong>Sisa Belum Terbagi: 0 ekor</strong></p>'+
    '<div><strong>Ukuran / BW</strong><div id="estSizes"></div><button type="button" id="addEstSize">+ Tambah Ukuran</button></div>'+
    '<div class="panel" style="margin:0"><strong>Pakan Terpakai Otomatis</strong><p id="estFeedPre" class="muted">Pre Starter: 0 Kg</p><p id="estFeedStarter" class="muted">Starter: 0 Kg</p><p id="estFeedFinisher" class="muted">Finisher: 0 Kg</p><p id="estFeedTotal"><strong>Total Pakan: 0 Kg</strong></p></div>'+
    '<label>Catatan<textarea name="notes"></textarea></label>'+
    '<div id="estPreview"></div>'+
    '<div class="inline-actions"><button id="estSave">Simpan Estimasi</button><button type="button" id="estCancel" style="display:none">Batal Edit</button></div>'+
    '</form></section>';

  html+='<section class="panel"><h3>Riwayat Estimasi</h3>'+txnEstimate.controls+'<div class="tablewrap"><table><thead><tr>'+
    '<th>Kandang</th><th>Tanggal</th><th>Umur</th><th>Sisa Ayam</th><th>BW Est.</th><th>Pakan</th><th>FCR Est.</th><th>IP Est.</th>'+
    '<th>Hasil Panen Est.</th><th>Biaya DOC + Pakan</th><th>Est. Laba</th><th>Laba / Ekor Chick-In</th><th>Aksi</th>'+
    '</tr></thead><tbody>'+
    pageRows.map(x=>{
      const a=d.assignments.find(a=>a.id===x.contract_assignment_id);
      const ci=d.chicks.find(c=>c.contract_assignment_id===x.contract_assignment_id);
      const sz=sizes.filter(s=>s.estimate_id===x.id);
      const birds=sz.reduce((s,v)=>s+prodNum(v.birds),0);
      const bio=sz.reduce((s,v)=>s+prodNum(v.birds)*prodNum(v.bw_kg),0);
      const bw=birds?bio/birds:0;
      const age=ci?prodAge(ci.arrived_on,x.estimated_on):0;
      // Estimasi dibuat sebelum panen Marketing pada tanggal yang sama.
      const priorHarvests=d.harvests.filter(h=>h.contract_assignment_id===x.contract_assignment_id&&h.harvested_on<x.estimated_on);
      const harvBirds=priorHarvests.reduce((s,h)=>s+prodNum(h.birds),0);
      const harvKg=priorHarvests.reduce((s,h)=>s+prodNum(h.net_weight_kg),0);
      const totalProjectedBirds=harvBirds+birds;
      const totalProjectedBio=harvKg+bio;
      const avgProjectedBw=totalProjectedBirds?totalProjectedBio/totalProjectedBirds:0;
      const fcr=totalProjectedBio?prodNum(x.feed_used_kg)/totalProjectedBio:0;
      const initial=ci?prodNum(ci.received)-prodNum(ci.doa):0;
      const surv=initial?Math.min(100,totalProjectedBirds/initial*100):0;
      const ip=age&&fcr?(surv*avgProjectedBw*100)/(age*fcr):0;
      const dyn=calcFinance(a,ci,sz,x.estimated_on);
      const revenue=x.estimated_revenue==null?dyn.revenue:prodNum(x.estimated_revenue);
      const cost=x.estimated_cost==null?dyn.cost:prodNum(x.estimated_cost);
      const profit=x.estimated_profit==null?dyn.profit:prodNum(x.estimated_profit);
      const perChick=x.profit_per_chick_in==null?dyn.perChick:prodNum(x.profit_per_chick_in);
      return '<tr><td>'+esc(a?prodAssignmentOption(d,a):'-')+'</td><td>'+prodDateId(x.estimated_on)+'</td><td>'+age+'</td><td>'+prodFmt(x.remaining_birds,0)+'</td><td>'+prodFmt(bw,3)+'</td><td>'+prodFmt(prodNum(x.feed_used_kg)/50,0)+' zak</td><td>'+prodFmt(fcr,3)+'</td><td>'+prodFmt(ip,1)+'</td>'+
        '<td>Rp '+prodFmt(revenue,0)+'</td><td>Rp '+prodFmt(cost,0)+'</td><td>Rp '+prodFmt(profit,0)+'</td><td>Rp '+prodFmt(perChick,0)+'</td>'+
        '<td><button type="button" data-edit-est="'+esc(x.id)+'">Edit</button></td></tr>';
    }).join('')+
    '</tbody></table></div>'+
    txnEstimate.pager+
    '<p class="muted">Rumus: hasil panen per ukuran/BW sesuai harga kontrak − (DOC Chick-In × harga DOC + pakan terpakai per fase × harga kontrak). Laba per ekor dibagi DOC Chick-In.</p></section>';

  layout(html);
  if(d.err||er.error||sr.error||rr.error)msg((d.err||er.error||sr.error||rr.error).message);

  const f=document.getElementById('prodEst');
  const holder=document.getElementById('estSizes');
  const saveBtn=document.getElementById('estSave');
  const cancelBtn=document.getElementById('estCancel');
  let draft=[{birds:0,bw:0}],editingId=null;

  const birdInt=v=>{
    const digits=String(v??'').replace(/\D/g,'');
    return digits?Number(digits):0;
  };
  const birdFmt=v=>{
    const n=Math.max(0,Math.trunc(Number(v)||0));
    return n?new Intl.NumberFormat('id-ID',{maximumFractionDigits:0}).format(n):'';
  };
  const updateUnallocated=()=>{
    const real=Math.trunc(prodNum(f.remaining.value));
    const allocated=draft.reduce((s,x)=>s+Math.trunc(Number(x.birds)||0),0);
    const left=real-allocated;
    const el=document.getElementById('estUnallocated');
    if(el)el.innerHTML='<strong>Sisa Belum Terbagi: '+prodFmt(Math.max(0,left),0)+' ekor</strong>'+(left<0?' <span class="error">· Melebihi sisa real '+prodFmt(Math.abs(left),0)+' ekor</span>':'');
    return left;
  };
  const feedTotals=()=>{
    const aid=f.assignment.value,date=f.date.value;
    let pre=0,starter=0,finisher=0,other=0;
    recs.filter(r=>r.contract_assignment_id===aid&&(!date||r.recorded_on<=date)).forEach(r=>{
      const item=d.feedItems.find(i=>i.id===r.feed_item_id),phase=String(item?.feed_phase||'').trim().toLowerCase(),kg=prodNum(r.feed_kg);
      if(phase.includes('pre'))pre+=kg;
      else if(phase.includes('finish')||phase.includes('finis'))finisher+=kg;
      else if(phase.includes('starter'))starter+=kg;
      else other+=kg;
    });
    return {pre,starter,finisher,other,total:pre+starter+finisher+other};
  };
  const currentFinancial=()=>{
    const a=d.assignments.find(x=>x.id===f.assignment.value);
    const ci=a&&d.chicks.find(c=>c.contract_assignment_id===a.id);
    return calcFinance(a,ci,draft.map(x=>({birds:x.birds,bw_kg:x.bw})),f.date.value);
  };
  const preview=()=>{
    const a=d.assignments.find(x=>x.id===f.assignment.value),ci=a&&d.chicks.find(c=>c.contract_assignment_id===a.id);
    const age=ci&&f.date.value?prodAge(ci.arrived_on,f.date.value):0;
    const harv=a?d.harvests.filter(h=>h.contract_assignment_id===a.id&&h.harvested_on<=f.date.value).reduce((s,h)=>s+prodNum(h.birds),0):0;
    const birds=draft.reduce((s,x)=>s+prodNum(x.birds),0);
    const bio=draft.reduce((s,x)=>s+prodNum(x.birds)*prodNum(x.bw),0);
    const bw=birds?bio/birds:0;
    const feeds=feedTotals();
    const fcr=bio?feeds.total/bio:0;
    const initial=ci?prodNum(ci.received)-prodNum(ci.doa):0;
    const surv=initial?Math.min(100,(prodNum(f.remaining.value)+harv)/initial*100):0;
    const ip=age&&fcr?(surv*bw*100)/(age*fcr):0;
    const fin=currentFinancial();
    document.getElementById('estAge').textContent='Umur: '+(ci?age+' hari':'-');
    document.getElementById('estActualHarvest').textContent='Panen aktual Marketing: '+prodFmt(harv,0)+' ekor';
    document.getElementById('estFeedPre').textContent='Pre Starter: '+prodFmt(feeds.pre,2)+' Kg';
    document.getElementById('estFeedStarter').textContent='Starter: '+prodFmt(feeds.starter,2)+' Kg';
    document.getElementById('estFeedFinisher').textContent='Finisher: '+prodFmt(feeds.finisher,2)+' Kg';
    document.getElementById('estFeedTotal').innerHTML='<strong>Total Pakan: '+prodFmt(feeds.total,2)+' Kg</strong>'+(feeds.other>0?' <span class="muted">· Fase lain: '+prodFmt(feeds.other,2)+' Kg</span>':'');
    document.getElementById('estPreview').innerHTML='<p><strong>BW Estimasi:</strong> '+prodFmt(bw,3)+' Kg · <strong>FCR:</strong> '+prodFmt(fcr,3)+' · <strong>IP:</strong> '+prodFmt(ip,1)+'</p>'+
      '<p><strong>BW Rataan:</strong> '+prodFmt(fin.avgBw,3)+' Kg</p>'+
      '<p><strong>Biaya DOC:</strong> Rp '+prodFmt(fin.docCost,0)+' ('+prodFmt(prodNum(ci?.received),0)+' × Rp '+prodFmt(fin.docPrice,0)+')</p>'+
      '<p><strong>Pre Starter:</strong> '+prodFmt(fin.preKg,2)+' Kg × Rp '+prodFmt(fin.prePrice,0)+' = Rp '+prodFmt(fin.preCost,0)+' · <strong>Starter:</strong> '+prodFmt(fin.starterKg,2)+' Kg × Rp '+prodFmt(fin.starterPrice,0)+' = Rp '+prodFmt(fin.starterCost,0)+' · <strong>Finisher:</strong> '+prodFmt(fin.finisherKg,2)+' Kg × Rp '+prodFmt(fin.finisherPrice,0)+' = Rp '+prodFmt(fin.finisherCost,0)+'</p>'+
      '<p><strong>Hasil Panen Est.:</strong> Rp '+prodFmt(fin.revenue,0)+' · <strong>Total Biaya DOC + Pakan:</strong> Rp '+prodFmt(fin.cost,0)+' · <strong>Est. Laba:</strong> Rp '+prodFmt(fin.profit,0)+' · <strong>Laba/Ekor Chick-In:</strong> Rp '+prodFmt(fin.perChick,0)+'</p>';
  };
  const syncEstimateDraftFromDom=()=>{
    holder.querySelectorAll('[data-est-birds]').forEach(x=>{const i=Number(x.dataset.estBirds);if(draft[i])draft[i].birds=birdInt(x.value)});
    holder.querySelectorAll('[data-est-bw]').forEach(x=>{const i=Number(x.dataset.estBw);if(draft[i])draft[i].bw=prodNum(x.value)});
  };
  const renderSizes=()=>{
    holder.innerHTML=draft.map((x,i)=>'<div class="est-size-row"><strong>Ukuran '+(i+1)+'</strong><label>Jumlah Ayam (ekor)<input type="text" inputmode="numeric" data-est-birds="'+i+'" value="'+birdFmt(x.birds)+'" placeholder="Contoh: 7.697" required></label><label>BW (kg)<input type="number" min="0.01" step="0.001" data-est-bw="'+i+'" value="'+(prodNum(x.bw)||'')+'" placeholder="Contoh: 1.15" required></label>'+(draft.length>1?'<button type="button" data-est-del="'+i+'">Hapus Ukuran</button>':'')+'</div>').join('');
    holder.querySelectorAll('[data-est-birds]').forEach(x=>x.oninput=()=>{
      const i=Number(x.dataset.estBirds);draft[i].birds=birdInt(x.value);x.value=birdFmt(draft[i].birds);updateUnallocated();preview();
    });
    holder.querySelectorAll('[data-est-bw]').forEach(x=>x.oninput=()=>{draft[Number(x.dataset.estBw)].bw=prodNum(x.value);preview()});
    holder.querySelectorAll('[data-est-del]').forEach(x=>x.onclick=()=>{syncEstimateDraftFromDom();draft.splice(Number(x.dataset.estDel),1);renderSizes();updateUnallocated();preview()});
  };
  document.getElementById('addEstSize').onclick=()=>{syncEstimateDraftFromDom();draft.push({birds:0,bw:0});renderSizes();updateUnallocated();preview()};

  const syncEstimateDate=()=>{
    const a=d.assignments.find(x=>x.id===f.assignment.value),ci=a&&d.chicks.find(c=>c.contract_assignment_id===a.id);
    if(!a||!ci){f.date.value='';document.getElementById('estDate').textContent='Tanggal Estimasi: -';return}
    const eligible=recs.filter(r=>r.contract_assignment_id===a.id&&prodNum(r.age_days)>=23).sort((x,y)=>prodNum(y.age_days)-prodNum(x.age_days));
    const autoDate=eligible[0]?.recorded_on||prodDateAdd(ci.arrived_on,22);
    f.date.value=autoDate;
    document.getElementById('estDate').textContent='Tanggal Estimasi: '+prodDateId(autoDate);
  };
  const syncExistingState=()=>{
    if(editingId)return;
    const existing=rows.find(x=>x.contract_assignment_id===f.assignment.value&&x.estimated_on===f.date.value);
    const el=document.getElementById('estExisting');
    if(existing){
      el.textContent='Estimasi umur '+prodAge(d.chicks.find(c=>c.contract_assignment_id===existing.contract_assignment_id)?.arrived_on,existing.estimated_on)+' sudah tersimpan. Gunakan tombol Edit pada Riwayat Estimasi.';
      saveBtn.disabled=true;
    }else{
      el.textContent='';
      saveBtn.disabled=false;
    }
  };
  f.assignment.onchange=()=>{
    syncEstimateDate();
    const a=d.assignments.find(x=>x.id===f.assignment.value),ci=a&&d.chicks.find(c=>c.contract_assignment_id===a.id);
    if(a&&ci&&f.date.value){
      const death=recs.filter(r=>r.contract_assignment_id===a.id&&r.recorded_on<=f.date.value).reduce((s,r)=>s+prodNum(r.mortality)+prodNum(r.culling),0);
      const harv=d.harvests.filter(h=>h.contract_assignment_id===a.id&&h.harvested_on<=f.date.value).reduce((s,h)=>s+prodNum(h.birds),0);
      f.remaining.value=Math.max(0,prodNum(ci.received)-prodNum(ci.doa)-death-harv);
    }else f.remaining.value='';
    draft=[{birds:0,bw:0}];renderSizes();updateUnallocated();syncExistingState();preview();
  };

  const resetEdit=()=>{
    editingId=null;f.assignment.disabled=false;f.notes.value='';saveBtn.textContent='Simpan Estimasi';cancelBtn.style.display='none';
    if(eligibleAssignments.length===1){f.assignment.value=eligibleAssignments[0].id;f.assignment.onchange()}
    else{f.assignment.value='';f.assignment.onchange()}
  };
  cancelBtn.onclick=resetEdit;

  bindTxnList(txnEstimate,()=>productionEstimatePage());

  root.querySelectorAll('[data-edit-est]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.id===btn.dataset.editEst);if(!x)return;
    editingId=x.id;
    f.assignment.value=x.contract_assignment_id;
    f.assignment.disabled=true;
    f.date.value=x.estimated_on;
    document.getElementById('estDate').textContent='Tanggal Estimasi: '+prodDateId(x.estimated_on);
    f.remaining.value=prodNum(x.remaining_birds);
    f.notes.value=x.notes||'';
    draft=sizes.filter(s=>s.estimate_id===x.id).map(s=>({birds:prodNum(s.birds),bw:prodNum(s.bw_kg)}));
    if(!draft.length)draft=[{birds:0,bw:0}];
    renderSizes();updateUnallocated();saveBtn.disabled=false;saveBtn.textContent='Update Estimasi';cancelBtn.style.display='';
    document.getElementById('estExisting').textContent='Mode Edit Estimasi umur '+prodAge(d.chicks.find(c=>c.contract_assignment_id===x.contract_assignment_id)?.arrived_on,x.estimated_on)+'.';
    preview();window.scrollTo({top:0,behavior:'smooth'});
  });

  renderSizes();syncEstimateDate();updateUnallocated();preview();
  if(eligibleAssignments.length===1){f.assignment.value=eligibleAssignments[0].id;f.assignment.onchange()}

  f.onsubmit=async e=>{
    e.preventDefault();
    const a=d.assignments.find(x=>x.id===f.assignment.value),ci=a&&d.chicks.find(c=>c.contract_assignment_id===a.id);
    if(!a||!ci)return msg('Pilih kontrak aktif yang sudah Chick-In.');
    if(prodAge(ci.arrived_on,f.date.value)<23)return msg('Estimasi dimulai umur 23 hari.');
    if(!editingId&&rows.some(x=>x.contract_assignment_id===a.id&&x.estimated_on===f.date.value))return msg('Estimasi umur ini sudah tersimpan. Gunakan Edit.');
    if(draft.some(x=>x.birds<=0||x.bw<=0))return msg('Isi jumlah ayam dan BW untuk semua ukuran.');
    const left=updateUnallocated();
    if(left<0)return msg('Jumlah ayam per ukuran melebihi Sisa Ayam Real.');
    if(left>0)return msg('Masih ada '+prodFmt(left,0)+' ekor yang belum terbagi ke ukuran.');
    const feeds=feedTotals(),fin=currentFinancial();
    const existingEstimate=editingId?rows.find(x=>x.id===editingId):null;
    let saveFeed=feeds.total,saveCost=fin.cost;
    if(existingEstimate){
      saveFeed=prodNum(existingEstimate.feed_used_kg);
      saveCost=prodNum(existingEstimate.estimated_cost);
    }
    const priorRevenue=d.harvests
      .filter(h=>h.contract_assignment_id===a.id&&h.harvested_on<f.date.value)
      .reduce((s,h)=>s+prodNum(h.total_amount),0);
    const projectedRemainingRevenue=draft.reduce((sum,x)=>{
      const price=d.livePrices.find(p=>p.contract_id===a.master_contract_id&&x.bw>=prodNum(p.min_weight_kg)&&(p.max_weight_kg==null||x.bw<prodNum(p.max_weight_kg)));
      return sum+prodNum(x.birds)*prodNum(x.bw)*prodNum(price?.price_per_kg);
    },0);
    const saveRevenue=priorRevenue+projectedRemainingRevenue;
    const saveProfit=saveRevenue-saveCost;
    const savePerChick=prodNum(ci.received)>0?saveProfit/prodNum(ci.received):0;
    const wasEdit=!!editingId;
    const {error:saveError}=await db.rpc('save_production_estimate_atomic',{
      p_id:editingId||null,
      p_assignment_id:a.id,
      p_barn_id:a.barn_id,
      p_estimated_on:f.date.value,
      p_remaining_birds:Math.trunc(prodNum(f.remaining.value)),
      p_feed_used_kg:saveFeed,
      p_notes:f.notes.value||null,
      p_estimated_revenue:saveRevenue,
      p_estimated_cost:saveCost,
      p_estimated_profit:saveProfit,
      p_profit_per_chick_in:savePerChick,
      p_sizes:draft.map(x=>({birds:Math.trunc(prodNum(x.birds)),bw_kg:prodNum(x.bw)}))
    });
    if(saveError)return msg(saveError.message);
    await productionEstimatePage();
    msg(wasEdit?'Estimasi berhasil diperbarui.':'Estimasi performa tersimpan.',true);
  };
}
const leagueAbkName=e=>e?.name||'-';
const leagueBarnName=(d,a)=>{
  const b=a&&d.barns.find(x=>x.id===a.barn_id);
  if(!b)return '-';
  const n=String(b.name||'').trim();
  return n.replace(/^Internal\s+/i,'Int.');
};
const leagueAssignmentLabel=(d,a)=>leagueBarnName(d,a);

async function loadAbkLeagueSetting(){
  const {data,error}=await db.from('abk_league_settings').select('id,season_start,reset_count,updated_at').eq('id',true).maybeSingle();
  return {data:data||null,error};
}

async function resetKlasemenAbkPage(){
  const leagueSetting=await loadAbkLeagueSetting();
  const current=leagueSetting.data?.season_start||prodToday();
  layout('<section class="panel"><h3>Reset Klasemen ABK</h3>'+
    '<p class="muted">Atur tanggal awal musim klasemen. Histori lama tetap tersimpan dan tidak dihapus.</p>'+
    '<form id="abkSeasonReset" class="form-vertical">'+
      '<label>Awal Musim<input type="date" name="season_start" value="'+esc(current)+'" required></label>'+
      '<button type="submit">Reset Klasemen dari Tanggal Ini</button>'+
    '</form>'+
    '<p class="muted">Periode klasemen aktif sejak '+prodDateId(current)+'.</p></section>');
  if(leagueSetting.error)msg(leagueSetting.error.message);
  const seasonForm=document.getElementById('abkSeasonReset');
  if(seasonForm)seasonForm.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(seasonForm),start=String(fd.get('season_start')||'');
    if(!start)return msg('Tanggal awal musim wajib diisi.');
    const {error}=await db.from('abk_league_settings').upsert({
      id:true,
      season_start:start,
      reset_count:prodNum(leagueSetting.data?.reset_count)+1,
      updated_by:session.user.id,
      updated_at:new Date().toISOString()
    });
    if(error)return msg(error.message);
    await resetKlasemenAbkPage();
    msg('Klasemen dimulai ulang dari '+prodDateId(start)+'. Histori lama tetap tersimpan.',true);
  };
}

async function leagueAbkPage(editSizeId=null){
  window.__leagueAbkState=window.__leagueAbkState||{assignment:'',abk:''};
  window.__leagueAbkHistoryFilter=window.__leagueAbkHistoryFilter||{barn:'',assignment:'',abk:'',status:'',from:'',to:'',shown:false};
  const d=await productionBase();
  const leagueSetting=await loadAbkLeagueSetting();
  const [rr,sr,cr,br]=await Promise.all([
    db.from('production_abk_results').select('*'),
    db.from('production_abk_result_sizes').select('*').order('harvest_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('contracts').select('id,doc_price,pre_starter_price,starter_price,finisher_price'),
    db.from('contract_bonuses').select('contract_id,metric,min_value,max_value,rupiah_per_kg')
  ]);
  const rows=rr.data||[],sizes=sr.data||[],leagueContracts=cr.data||[],leagueBonuses=br.data||[];
  const seasonStart=leagueSetting.data?.season_start||'0000-00-00';

  const calcResult=x=>{
    const a=d.assignments.find(a=>a.id===x.contract_assignment_id);
    const ci=d.chicks.find(c=>c.contract_assignment_id===x.contract_assignment_id);
    const link=d.links.find(l=>l.contract_assignment_id===x.contract_assignment_id&&l.abk_id===x.abk_id);
    const sz=sizes.filter(s=>s.result_id===x.id);
    const birds=sz.reduce((s,v)=>s+prodNum(v.birds),0);
    const kg=sz.reduce((s,v)=>s+prodNum(v.weight_kg),0);
    const bw=birds?kg/birds:0;
    const feed=(prodNum(link?.feed_pre_bags)+prodNum(link?.feed_starter_bags)+prodNum(link?.feed_finisher_bags))*50;
    const fcr=kg?feed/kg:0;
    const weightedAge=birds&&ci?sz.reduce((s,v)=>s+prodAge(ci.arrived_on,v.harvest_date)*prodNum(v.birds),0)/birds:0;
    const initialShare=prodNum(link?.initial_birds);
    const surv=initialShare?Math.min(100,birds/initialShare*100):0;
    const ip=initialShare&&weightedAge&&fcr?(surv*bw*100)/(weightedAge*fcr):0;
    let revenue=0;
    for(const s of sz){
      const av=prodNum(s.birds)?prodNum(s.weight_kg)/prodNum(s.birds):0;
      const p=d.livePrices.find(p=>p.contract_id===a?.master_contract_id&&av>=prodNum(p.min_weight_kg)&&(p.max_weight_kg==null||av<prodNum(p.max_weight_kg)));
      revenue+=prodNum(s.weight_kg)*prodNum(p?.price_per_kg);
    }

    const contract=leagueContracts.find(c=>c.id===a?.master_contract_id);
    const sapronakCost=
      initialShare*prodNum(contract?.doc_price)+
      prodNum(link?.feed_pre_bags)*50*prodNum(contract?.pre_starter_price)+
      prodNum(link?.feed_starter_bags)*50*prodNum(contract?.starter_price)+
      prodNum(link?.feed_finisher_bags)*50*prodNum(contract?.finisher_price);

    const matchBonus=(metric,value)=>{
      const row=leagueBonuses.find(b=>
        b.contract_id===a?.master_contract_id&&
        b.metric===metric&&
        (b.min_value==null||value>=prodNum(b.min_value))&&
        (b.max_value==null||value<prodNum(b.max_value))
      );
      return prodNum(row?.rupiah_per_kg);
    };

    const ipBonus=kg*matchBonus('IP',ip);
    const perfRows=d.standards
      .filter(s=>s.contract_id===a?.master_contract_id&&s.template_name===a?.performance_template_name&&s.std_fcr!=null)
      .sort((u,v)=>prodNum(u.age_days)-prodNum(v.age_days));
    let stdFcr=0;
    if(perfRows.length){
      const exact=perfRows.find(s=>prodNum(s.age_days)===weightedAge);
      if(exact){
        stdFcr=prodNum(exact.std_fcr);
      }else{
        const lower=[...perfRows].reverse().find(s=>prodNum(s.age_days)<=weightedAge);
        const upper=perfRows.find(s=>prodNum(s.age_days)>=weightedAge);
        if(lower&&upper&&prodNum(upper.age_days)!==prodNum(lower.age_days)){
          const span=prodNum(upper.age_days)-prodNum(lower.age_days);
          const ratio=(weightedAge-prodNum(lower.age_days))/span;
          stdFcr=prodNum(lower.std_fcr)+(prodNum(upper.std_fcr)-prodNum(lower.std_fcr))*ratio;
        }else{
          stdFcr=prodNum((lower||upper)?.std_fcr);
        }
      }
    }
    const fcrDiff=stdFcr?stdFcr-fcr:0;
    const fcrBonus=fcrDiff>0?kg*matchBonus('FCR_DIFFERENCE',fcrDiff):0;

    const profit=revenue-sapronakCost+ipBonus+fcrBonus;
    const perBird=birds?profit/birds:0;

    return {...x,a,birds,kg,bw,feed,fcr,stdFcr,fcrDiff,age:weightedAge,initialBirds:initialShare,survival:surv,ip,revenue,sapronakCost,ipBonus,fcrBonus,profit,perBird,complete:!!link?.basics_locked_at&&initialShare>0&&birds>0&&kg>0&&feed>0};
  };

  const calculated=rows.map(calcResult);
  const seasonal=calculated.filter(x=>x.complete&&String(x.harvest_date||'')>=seasonStart);
  const cumulativeMap=new Map();
  seasonal.forEach(x=>{
    if(!cumulativeMap.has(x.abk_id))cumulativeMap.set(x.abk_id,{...x,birds:0,kg:0,feed:0,profit:0,ipWeighted:0,periods:0});
    const g=cumulativeMap.get(x.abk_id);
    g.birds+=prodNum(x.birds);g.kg+=prodNum(x.kg);g.feed+=prodNum(x.feed);g.profit+=prodNum(x.profit);g.ipWeighted+=prodNum(x.ip)*prodNum(x.birds);g.periods+=1;g.a=x.a;
  });
  const eligible=[...cumulativeMap.values()].map(g=>({...g,bw:g.birds?g.kg/g.birds:0,fcr:g.kg?g.feed/g.kg:0,ip:g.birds?g.ipWeighted/g.birds:0,perBird:g.birds?g.profit/g.birds:0}));
  const max=k=>Math.max(...eligible.map(x=>prodNum(x[k])),0),min=k=>Math.min(...eligible.map(x=>prodNum(x[k])).filter(v=>v>0),0);
  eligible.forEach(x=>{const hi=k=>max(k)?prodNum(x[k])/max(k):0;const lo=k=>prodNum(x[k])>0&&min(k)>0?min(k)/prodNum(x[k]):0;x._score=hi('perBird')*.35+hi('ip')*.30+lo('fcr')*.20+hi('bw')*.15});
  eligible.sort((a,b)=>b._score-a._score);eligible.forEach((x,i)=>x.rank=i+1);

  let history=sizes.map(s=>{
    const r=rows.find(x=>x.id===s.result_id),a=r&&d.assignments.find(x=>x.id===r.contract_assignment_id),e=r&&d.abks.find(x=>x.id===r.abk_id);
    const ci=a&&d.chicks.find(c=>c.contract_assignment_id===a.id);
    const bw=prodNum(s.birds)?prodNum(s.weight_kg)/prodNum(s.birds):0;
    const price=d.livePrices.find(p=>p.contract_id===a?.master_contract_id&&bw>=prodNum(p.min_weight_kg)&&(p.max_weight_kg==null||bw<prodNum(p.max_weight_kg)));
    const pricePerKg=prodNum(price?.price_per_kg);
    const amount=prodNum(s.weight_kg)*pricePerKg;
    const age=ci&&s.harvest_date?prodAge(ci.arrived_on,s.harvest_date):0;
    return {s,r,a,e,bw,age,pricePerKg,amount};
  }).filter(x=>x.r).sort((a,b)=>String(b.s.harvest_date||'').localeCompare(String(a.s.harvest_date||'')));
  const selected=editSizeId?history.find(x=>x.s.id===editSizeId):null;
  const hf=window.__leagueAbkHistoryFilter;
  const historyAssignments=d.assignments.filter(a=>history.some(x=>x.r?.contract_assignment_id===a.id));
  const historyBarnIds=new Set(historyAssignments.map(a=>a.barn_id));
  const historyBarns=d.barns.filter(b=>historyBarnIds.has(b.id));
  const historyAbkIds=new Set(history.map(x=>x.r?.abk_id).filter(Boolean));
  const historyAbks=d.abks.filter(a=>historyAbkIds.has(a.id));
  const visibleHistory=selected?[selected]:(hf.shown?history.filter(x=>
    (!hf.barn||x.a?.barn_id===hf.barn)&&
    (!hf.assignment||x.r?.contract_assignment_id===hf.assignment)&&
    (!hf.abk||x.r?.abk_id===hf.abk)&&
    (!hf.status||(hf.status==='PROSES'?x.a?.active===true:x.a?.active===false))&&
    (!hf.from||String(x.s.harvest_date||'')>=hf.from)&&
    (!hf.to||String(x.s.harvest_date||'')<=hf.to)
  ):[]);

  let html='<section class="panel"><h3>'+(selected?'Edit Panen ABK':'Liga ABK')+'</h3>'+
    '<p class="muted">Pilih kandang dan ABK, isi Populasi Awal, kunci Pakan, lalu input Panen.</p>'+
    '<form id="abkForm" class="form-vertical">'+
      '<label>Kandang Aktif<select name="assignment" required '+(selected?'disabled':'')+'><option value="">Pilih</option>'+
        d.assignments.filter(a=>a.active&&d.chicks.some(c=>c.contract_assignment_id===a.id)).map(a=>'<option value="'+esc(a.id)+'" '+(selected?.r.contract_assignment_id===a.id?'selected':'')+'>'+esc(leagueAssignmentLabel(d,a))+'</option>').join('')+
      '</select></label>'+
      '<label>ABK<select name="abk" required '+(selected?'disabled':'')+'><option value="">Pilih kontrak dulu</option></select></label>'+
      '<section class="panel" style="margin:0"><h4>Data ABK</h4>'+
        '<label>Populasi Awal ABK (ekor)<input name="initial_birds" data-number="1" inputmode="decimal" placeholder="Contoh: 8.250"></label>'+
        (profile.role==='ADMIN'?'<button type="button" id="saveAbkPopulation">Simpan Populasi Awal</button>':'')+
        '<p class="muted">Populasi Awal adalah data dasar ABK dan tidak ikut kunci transaksi kontrak.</p>'+
        '<p class="muted">Penempatan Pakan mengikuti kontrak aktif. Input dalam zak, 1 zak = 50 kg.</p>'+
        '<label>Pre Starter (zak)<input name="pre_bags" data-number="1" inputmode="decimal" placeholder="Contoh: 24"></label>'+
        '<label>Starter (zak)<input name="starter_bags" data-number="1" inputmode="decimal" placeholder="Contoh: 70"></label>'+
        '<label>Finisher (zak)<input name="finisher_bags" data-number="1" inputmode="decimal" placeholder="Contoh: 96"></label>'+
        (profile.role==='ADMIN'?'<button type="button" id="lockAbkBasics">Simpan & Kunci Pakan</button>':'')+
        '<p class="muted">Pakan dan Panen ABK mengikuti kontrak aktif dan terkunci saat periode kontrak ditutup.</p>'+
        '<p id="abkBasicsStatus" class="muted">Pilih ABK untuk melihat status.</p>'+
      '</section>'+
      '<fieldset id="abkHarvestFields" disabled style="border:0;padding:0;margin:0">'+
        '<h4>Panen ABK</h4>'+
        '<p class="muted">Satu tanggal boleh memiliki beberapa transaksi panen. Setiap Simpan menambah transaksi baru.</p>'+
        '<label>Tanggal Panen<input type="date" name="date" value="'+esc(selected?.s.harvest_date||prodToday())+'" required></label>'+
        '<p id="abkAge" class="muted">Umur panen: -</p>'+
        '<label>Ekor<input name="birds" data-number="1" inputmode="decimal" value="'+(selected?fmtNumber(selected.s.birds):'')+'" placeholder="Contoh: 1.920" required></label>'+
        '<label>KG<input name="kg" data-number="1" inputmode="decimal" value="'+(selected?fmtNumber(selected.s.weight_kg):'')+'" placeholder="Contoh: 3.096,70" required></label>'+
        '<button>'+(selected?'Simpan Perubahan':'Simpan Panen ABK')+'</button>'+
        (selected?' <button type="button" id="cancelAbkEdit">Batal Edit</button>':'')+
      '</fieldset>'+
    '</form></section>';

  const cycleFilterRows=historyAssignments.filter(a=>!hf.barn||a.barn_id===hf.barn);
  const abkFilterRows=historyAbks.filter(e=>history.some(x=>
    x.r?.abk_id===e.id&&
    (!hf.barn||x.a?.barn_id===hf.barn)&&
    (!hf.assignment||x.r?.contract_assignment_id===hf.assignment)
  ));
  html+='<section class="panel"><h3>Riwayat Panen ABK Lengkap</h3>'+
    '<form id="abkHistoryFilter" class="form-vertical compact-form" style="margin-bottom:10px">'+
      '<label>Pilih Kandang<select name="barn"><option value="">Semua Kandang</option>'+historyBarns.map(b=>'<option value="'+esc(b.id)+'" '+(hf.barn===b.id?'selected':'')+'>'+esc((b.code?b.code+' · ':'')+(b.name||''))+'</option>').join('')+'</select></label>'+
      '<label>Pilih Siklus<select name="assignment" '+(!hf.barn?'disabled':'')+'><option value="">Semua Siklus</option>'+cycleFilterRows.map(a=>'<option value="'+esc(a.id)+'" '+(hf.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED'))+'</option>').join('')+'</select></label>'+
      '<label>Pilih ABK<select name="abk"><option value="">Semua ABK</option>'+abkFilterRows.map(e=>'<option value="'+esc(e.id)+'" '+(hf.abk===e.id?'selected':'')+'>'+esc(leagueAbkName(e))+'</option>').join('')+'</select></label>'+
      '<label>Status<select name="status"><option value="">Semua Status</option><option value="PROSES" '+(hf.status==='PROSES'?'selected':'')+'>PROSES</option><option value="CLOSED" '+(hf.status==='CLOSED'?'selected':'')+'>CLOSED</option></select></label>'+
      '<label>Tanggal Dari<input type="date" name="from" value="'+esc(hf.from||'')+'"></label>'+
      '<label>Tanggal Sampai<input type="date" name="to" value="'+esc(hf.to||'')+'"></label>'+
      '<div class="inline-actions"><button type="submit">Cari</button><button type="button" id="abkHistoryReset">Reset</button></div>'+
    '</form>'+
    '<p class="muted">'+(hf.shown?'Total '+visibleHistory.length+' transaksi sesuai filter. Geser kanan/kiri untuk melihat seluruh rincian.':'Pilih filter lalu klik Cari untuk menampilkan riwayat.')+'</p>'+
    (hf.shown?
      '<div class="tablewrap" style="overflow-x:auto;max-height:none"><table style="min-width:820px"><thead><tr><th>Tanggal</th><th>ABK</th><th>Kandang</th><th>Status</th><th>Umur</th><th>Ekor</th><th>KG</th><th>BW</th><th>Aksi</th></tr></thead><tbody>'+
      visibleHistory.map(x=>{const locked=!x.a?.active;return '<tr><td>'+prodDateId(x.s.harvest_date)+'</td><td>'+esc(leagueAbkName(x.e))+'</td><td>'+esc(leagueBarnName(d,x.a))+'</td><td>'+(locked?'CLOSED':'PROSES')+'</td><td>'+prodFmt(x.age,0)+' hari</td><td>'+fmtNumber(x.s.birds)+'</td><td>'+fmtNumber(x.s.weight_kg)+'</td><td>'+prodFmt(x.bw,2)+' kg</td><td>'+(locked?'<strong>Terkunci</strong>':'<button type="button" data-edit-abk-harvest="'+esc(x.s.id)+'">Edit</button> <button type="button" data-delete-abk-harvest="'+esc(x.s.id)+'">Hapus</button>')+'</td></tr>'}).join('')+
      '</tbody></table></div>'+(!visibleHistory.length?'<p>Data riwayat tidak ditemukan sesuai filter.</p>':'')
      :''
    )+'</section>';



  layout(html);
  if(d.err||rr.error||sr.error)msg((d.err||rr.error||sr.error).message);
  bindNumberInputs();

  const historyFilter=document.getElementById('abkHistoryFilter');
  if(historyFilter&&!selected){
    const barnSel=historyFilter.elements.barn;
    const cycleSel=historyFilter.elements.assignment;
    const abkSel=historyFilter.elements.abk;
    barnSel.onchange=()=>{
      const bid=barnSel.value||'';
      const rows=historyAssignments.filter(a=>!bid||a.barn_id===bid);
      cycleSel.disabled=!bid;
      cycleSel.innerHTML='<option value="">Semua Siklus</option>'+rows.map(a=>'<option value="'+esc(a.id)+'">'+esc(assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED'))+'</option>').join('');
      const ids=new Set(history.filter(x=>!bid||x.a?.barn_id===bid).map(x=>x.r?.abk_id).filter(Boolean));
      abkSel.innerHTML='<option value="">Semua ABK</option>'+d.abks.filter(e=>ids.has(e.id)).map(e=>'<option value="'+esc(e.id)+'">'+esc(leagueAbkName(e))+'</option>').join('');
    };
    cycleSel.onchange=()=>{
      const aid=cycleSel.value||'';
      const bid=barnSel.value||'';
      const ids=new Set(history.filter(x=>
        (!bid||x.a?.barn_id===bid)&&
        (!aid||x.r?.contract_assignment_id===aid)
      ).map(x=>x.r?.abk_id).filter(Boolean));
      abkSel.innerHTML='<option value="">Semua ABK</option>'+d.abks.filter(e=>ids.has(e.id)).map(e=>'<option value="'+esc(e.id)+'">'+esc(leagueAbkName(e))+'</option>').join('');
    };
    historyFilter.onsubmit=async ev=>{
      ev.preventDefault();
      const fd=new FormData(historyFilter);
      let from=String(fd.get('from')||''),to=String(fd.get('to')||'');
      if(from&&to&&from>to){const t=from;from=to;to=t;}
      window.__leagueAbkHistoryFilter={
        barn:String(fd.get('barn')||''),
        assignment:String(fd.get('barn')||'')?String(fd.get('assignment')||''):'',
        abk:String(fd.get('abk')||''),
        status:String(fd.get('status')||''),
        from,to,shown:true
      };
      await leagueAbkPage();
    };
    const resetHistory=document.getElementById('abkHistoryReset');
    if(resetHistory)resetHistory.onclick=async()=>{
      window.__leagueAbkHistoryFilter={barn:'',assignment:'',abk:'',status:'',from:'',to:'',shown:false};
      await leagueAbkPage();
    };
  }

  const f=document.getElementById('abkForm');
  if(!selected&&window.__leagueAbkState.assignment){
    const savedAssignment=d.assignments.find(a=>a.id===window.__leagueAbkState.assignment&&a.active);
    if(savedAssignment)f.assignment.value=savedAssignment.id;
  }
  const harvestFields=document.getElementById('abkHarvestFields');
  const savePopulationButton=document.getElementById('saveAbkPopulation');
  const lockButton=document.getElementById('lockAbkBasics');

  const syncAbkContext=()=>{
    const link=d.links.find(l=>l.contract_assignment_id===f.assignment.value&&l.abk_id===f.abk.value);
    const locked=!!link?.basics_locked_at;
    f.initial_birds.value=link?.initial_birds?fmtNumber(link.initial_birds):'';
    f.pre_bags.value=link?.feed_pre_bags!=null?prodFmt(link.feed_pre_bags,2):'';
    f.starter_bags.value=link?.feed_starter_bags!=null?prodFmt(link.feed_starter_bags,2):'';
    f.finisher_bags.value=link?.feed_finisher_bags!=null?prodFmt(link.feed_finisher_bags,2):'';

    f.initial_birds.readOnly=profile.role!=='ADMIN';
    [f.pre_bags,f.starter_bags,f.finisher_bags].forEach(inp=>inp.readOnly=locked||profile.role!=='ADMIN');
    if(savePopulationButton)savePopulationButton.disabled=!link;
    if(lockButton){
      lockButton.disabled=!link||locked||!prodNum(link?.initial_birds);
      lockButton.textContent=locked?'Pakan Terkunci':'Simpan & Kunci Pakan';
    }
    const status=document.getElementById('abkBasicsStatus');
    if(status)status.textContent=!link?'Pilih ABK untuk melihat status.':
      'Populasi '+(link.initial_birds?fmtNumber(link.initial_birds)+' ekor':'belum diisi')+
      ' · Pakan '+(locked?'TERKUNCI '+prodFmt(prodNum(link.feed_pre_bags)+prodNum(link.feed_starter_bags)+prodNum(link.feed_finisher_bags),2)+' zak':'belum dikunci');
    harvestFields.disabled=!locked;

    const ci=d.chicks.find(c=>c.contract_assignment_id===f.assignment.value);
    document.getElementById('abkAge').textContent='Umur panen: '+(ci&&f.date.value?prodAge(ci.arrived_on,f.date.value)+' hari':'-');
  };

  const refreshAbk=()=>{
    const current=f.abk.value;
    const links=d.links.filter(l=>l.contract_assignment_id===f.assignment.value),ids=new Set(links.map(l=>l.abk_id));
    f.abk.innerHTML='<option value="">Pilih ABK</option>'+d.abks.filter(a=>ids.has(a.id)).map(a=>'<option value="'+esc(a.id)+'">'+esc(leagueAbkName(a))+'</option>').join('');
    if(selected)f.abk.value=selected.r.abk_id;
    else if(ids.has(window.__leagueAbkState.abk))f.abk.value=window.__leagueAbkState.abk;
    else if(ids.has(current))f.abk.value=current;
    window.__leagueAbkState.assignment=f.assignment.value||'';
    window.__leagueAbkState.abk=f.abk.value||'';
    syncAbkContext();
  };

  refreshAbk();
  if(!selected)f.assignment.onchange=()=>{
    window.__leagueAbkState.assignment=f.assignment.value||'';
    window.__leagueAbkState.abk='';
    refreshAbk();
  };
  f.abk.onchange=async()=>{
    window.__leagueAbkState.assignment=f.assignment.value||'';
    window.__leagueAbkState.abk=f.abk.value||'';
    await leagueAbkPage();
  };
  f.date.onchange=syncAbkContext;

  if(savePopulationButton)savePopulationButton.onclick=async()=>{
    const link=d.links.find(l=>l.contract_assignment_id===f.assignment.value&&l.abk_id===f.abk.value);
    if(!link)return msg('Pilih Kandang / Kontrak dan ABK terlebih dahulu.');
    const initialBirds=Math.trunc(normalizeInputID(f.initial_birds.value)||0);
    if(initialBirds<=0)return msg('Populasi Awal ABK wajib lebih dari 0.');
    const {error}=await db.rpc('save_production_abk_initial_population_atomic',{
      p_link_id:link.id,
      p_initial_birds:initialBirds
    });
    if(error)return msg(error.message);
    window.__leagueAbkState.assignment=f.assignment.value||'';
    window.__leagueAbkState.abk=f.abk.value||'';
    await leagueAbkPage();
    msg('Populasi Awal ABK tersimpan.',true);
  };

  if(lockButton)lockButton.onclick=async()=>{
    const a=d.assignments.find(x=>x.id===f.assignment.value);
    const link=d.links.find(l=>l.contract_assignment_id===f.assignment.value&&l.abk_id===f.abk.value);
    if(!a||!link)return msg('Pilih Kandang / Kontrak dan ABK terlebih dahulu.');
    const initialBirds=prodNum(link.initial_birds);
    const pre=normalizeInputID(f.pre_bags.value),starter=normalizeInputID(f.starter_bags.value),finisher=normalizeInputID(f.finisher_bags.value);
    if(initialBirds<=0)return msg('Simpan Populasi Awal ABK terlebih dahulu.');
    if(pre==null||starter==null||finisher==null||pre<0||starter<0||finisher<0)return msg('Total Penempatan Pakan harus berupa angka yang benar.');
    if(pre+starter+finisher<=0)return msg('Total Penempatan Pakan wajib diisi.');
    const {error}=await db.rpc('lock_production_abk_basics_atomic',{
      p_link_id:link.id,
      p_initial_birds:initialBirds,
      p_feed_pre_bags:pre,
      p_feed_starter_bags:starter,
      p_feed_finisher_bags:finisher
    });
    if(error)return msg(error.message);
    window.__leagueAbkState.assignment=f.assignment.value||'';
    window.__leagueAbkState.abk=f.abk.value||'';
    await leagueAbkPage();
    msg('Penempatan Pakan ABK tersimpan dan terkunci. Silakan lanjut ke Panen.',true);
  };

  f.onsubmit=async e=>{
    e.preventDefault();
    const a=d.assignments.find(x=>x.id===f.assignment.value);
    const link=d.links.find(l=>l.contract_assignment_id===f.assignment.value&&l.abk_id===f.abk.value);
    if(!a||!f.abk.value)return msg('Pilih kontrak dan ABK.');
    if(!link?.basics_locked_at)return msg('Simpan & Kunci Pakan ABK terlebih dahulu.');
    const birds=normalizeInputID(f.birds.value),kg=normalizeInputID(f.kg.value);
    if(!(birds>0))return msg('Ekor harus lebih dari 0.');
    if(!(kg>0))return msg('KG harus lebih dari 0.');
    if(!Number.isInteger(birds))return msg('Ekor harus berupa jumlah ayam bulat.');

    const rpc=selected?'update_production_abk_harvest_atomic':'save_production_abk_harvest_atomic';
    const params=selected?{
      p_size_id:selected.s.id,
      p_harvest_date:f.date.value,
      p_birds:birds,
      p_weight_kg:kg,
      p_feed_pre_kg:0,
      p_feed_starter_kg:0,
      p_feed_finisher_kg:0
    }:{
      p_assignment_id:a.id,
      p_barn_id:a.barn_id,
      p_abk_id:f.abk.value,
      p_harvest_date:f.date.value,
      p_birds:birds,
      p_weight_kg:kg,
      p_feed_pre_kg:0,
      p_feed_starter_kg:0,
      p_feed_finisher_kg:0
    };
    const {error}=await db.rpc(rpc,params);
    if(error)return msg(error.message);
    window.__leagueAbkState.assignment=f.assignment.value||'';
    window.__leagueAbkState.abk=f.abk.value||'';
    await leagueAbkPage();
    msg(selected?'Panen ABK berhasil diperbarui.':'Panen ABK tersimpan sebagai transaksi baru.',true);
  };

  document.querySelectorAll('[data-edit-abk-harvest]').forEach(btn=>btn.onclick=()=>leagueAbkPage(btn.dataset.editAbkHarvest));
  document.querySelectorAll('[data-delete-abk-harvest]').forEach(btn=>btn.onclick=async()=>{
    if(!confirm('Hapus transaksi Panen ABK ini?'))return;
    const {error}=await db.rpc('delete_production_abk_harvest_atomic',{p_size_id:btn.dataset.deleteAbkHarvest});
    if(error)return msg(error.message);
    await leagueAbkPage();
    msg('Panen ABK berhasil dihapus.',true);
  });
  const cancel=document.getElementById('cancelAbkEdit');
  if(cancel)cancel.onclick=()=>leagueAbkPage();
}
async function productionRecapPage(){
  const d=await productionBase();
  const [cpr,pr,fr,...feedResponses]=await Promise.all([
    db.from('company_profile').select('company_name,legal_name,address,phone,email,website,logo_url').eq('id',true).maybeSingle(),
    db.from('profiles').select('user_id,full_name,role,active').eq('role','PPL'),
    db.from('rhpp_system_final').select('contract_assignment_id,chick_in_birds,total_harvest_birds,total_harvest_kg,avg_bw_kg,weighted_age,net_feed_kg,fcr_actual,ip,closed_on'),
    ...d.assignments.map(a=>db.rpc('production_feed_stock',{p_contract_assignment_id:a.id}))
  ]);
  const company=cpr.data||{};
  const pplRows=pr.data||[];
  const finals=fr.data||[];
  const feedByAssignment=new Map();
  d.assignments.forEach((a,i)=>feedByAssignment.set(a.id,feedResponses[i]?.data||[]));

  const dateOfAssignment=a=>{
    const ci=d.chicks.find(c=>c.contract_assignment_id===a.id);
    return ci?.arrived_on||a.start_date||'';
  };
  const allDates=d.assignments.map(dateOfAssignment).filter(Boolean).sort();
  const minDate=allDates[0]||prodToday();
  const maxDate=allDates[allDates.length-1]||prodToday();

  window.__productionRecapState=window.__productionRecapState||{
    from:minDate,to:maxDate,barn:'',ppl:'',assignment:'',status:'',shown:false
  };
  const st=window.__productionRecapState;
  if(st.barn===undefined)st.barn='';
  if(st.ppl===undefined)st.ppl='';
  if(st.assignment===undefined)st.assignment='';
  if(st.status===undefined)st.status='';
  let from=st.from||minDate;
  let to=st.to||maxDate;
  if(from>to){const t=from;from=to;to=t;}

  const pplName=id=>pplRows.find(p=>p.user_id===id)?.full_name||'-';
  const barnIds=new Set(d.assignments.map(a=>a.barn_id));
  const filterBarns=d.barns.filter(b=>barnIds.has(b.id));
  const filterPplIds=[...new Set(d.assignments.map(a=>a.ppl_id).filter(Boolean))];
  const filterPpls=filterPplIds.map(id=>({id,name:pplName(id)})).sort((a,b)=>a.name.localeCompare(b.name));
  const cycleCandidates=d.assignments.filter(a=>
    (!st.barn||a.barn_id===st.barn)&&
    (!st.ppl||a.ppl_id===st.ppl)
  );

  const inRange=d.assignments.filter(a=>{
    const dt=dateOfAssignment(a);
    return dt&&dt>=from&&dt<=to&&
      (!st.barn||a.barn_id===st.barn)&&
      (!st.ppl||a.ppl_id===st.ppl)&&
      (!st.assignment||a.id===st.assignment)&&
      (!st.status||(st.status==='PROSES'?a.active===true:a.active===false));
  });

  const cycleMap=new Map();
  [...d.assignments].sort((a,b)=>String(dateOfAssignment(a)).localeCompare(String(dateOfAssignment(b)))).forEach(a=>{
    const arr=cycleMap.get(a.barn_id)||[];
    arr.push(a.id);
    cycleMap.set(a.barn_id,arr);
  });

  const feedFor=a=>(feedByAssignment.get(a.id)||[]).reduce((sum,x)=>{
    const delivered=prodNum(x.sent_units)+prodNum(x.external_units)-prodNum(x.returned_units);
    return sum+Math.max(0,delivered)*prodNum(x.kg_per_unit);
  },0);

  const rows=inRange.map(a=>{
    const ci=d.chicks.find(c=>c.contract_assignment_id===a.id);
    const b=d.barns.find(x=>x.id===a.barn_id);
    const cycles=cycleMap.get(a.barn_id)||[];
    const final=!a.active?finals.find(f=>f.contract_assignment_id===a.id):null;

    if(final){
      const chickIn=prodNum(final.chick_in_birds);
      const chickOut=prodNum(final.total_harvest_birds);
      const mortBirds=Math.max(0,chickIn-chickOut);
      const mortPct=chickIn?Math.min(100,mortBirds/chickIn*100):0;
      const kg=prodNum(final.total_harvest_kg);
      const avg=prodNum(final.avg_bw_kg);
      const age=prodNum(final.weighted_age);
      const feed=prodNum(final.net_feed_kg);
      const fcr=prodNum(final.fcr_actual);
      const ip=prodNum(final.ip);
      return {
        a,b,ci,ppl:pplName(a.ppl_id),status:'CLOSED',
        chickIn,chickOut,mortBirds,mortPct,kg,avg,age,feed,fcr,ip,
        cycle:Math.max(1,cycles.indexOf(a.id)+1)
      };
    }

    const hs=d.harvests.filter(h=>h.contract_assignment_id===a.id);
    const chickIn=ci?Math.max(0,prodNum(ci.received)-prodNum(ci.doa)):0;
    const chickOut=hs.reduce((sum,h)=>sum+prodNum(h.birds),0);
    const mortBirds=Math.max(0,chickIn-chickOut);
    const mortPct=chickIn?Math.min(100,mortBirds/chickIn*100):0;
    const kg=hs.reduce((sum,h)=>sum+prodNum(h.net_weight_kg),0);
    const avg=chickOut?kg/chickOut:0;
    const age=chickOut&&ci?hs.reduce((sum,h)=>sum+prodAge(ci.arrived_on,h.harvested_on)*prodNum(h.birds),0)/chickOut:0;
    const feed=feedFor(a);
    const fcr=kg?feed/kg:0;
    const survival=chickIn?Math.min(100,chickOut/chickIn*100):0;
    const ip=age&&fcr&&avg?(survival*avg*100)/(age*fcr):0;
    return {
      a,b,ci,ppl:pplName(a.ppl_id),status:'PROSES',
      chickIn,chickOut,mortBirds,mortPct,kg,avg,age,feed,fcr,ip,
      cycle:Math.max(1,cycles.indexOf(a.id)+1)
    };
  }).sort((x,y)=>String(dateOfAssignment(x.a)).localeCompare(String(dateOfAssignment(y.a))));

  const totals=rows.reduce((o,x)=>{
    o.chickIn+=x.chickIn;o.chickOut+=x.chickOut;o.mortBirds+=x.mortBirds;
    o.kg+=x.kg;o.feed+=x.feed;o.ageWeight+=x.age*Math.max(1,x.chickOut);
    return o;
  },{chickIn:0,chickOut:0,mortBirds:0,kg:0,feed:0,ageWeight:0});
  const ageWeightBase=rows.reduce((sum,x)=>sum+Math.max(1,x.chickOut),0);
  const totalAge=ageWeightBase?totals.ageWeight/ageWeightBase:0;
  const totalAvg=totals.chickOut?totals.kg/totals.chickOut:0;
  const totalMortPct=totals.chickIn?Math.min(100,totals.mortBirds/totals.chickIn*100):0;
  const totalFcr=totals.kg?totals.feed/totals.kg:0;
  const totalSurvival=totals.chickIn?Math.min(100,totals.chickOut/totals.chickIn*100):0;
  const totalIp=totalAge&&totalFcr&&totalAvg?(totalSurvival*totalAvg*100)/(totalAge*totalFcr):0;

  const scopeLabel=profile?.role==='PPL'?'Kandang yang menjadi penugasan PPL ini':'Seluruh kandang / PPL';
  const fileBase=('Rekap_Produksi_PPL_'+from+'_sampai_'+to).replace(/[^A-Za-z0-9_-]+/g,'_');
  const filterSummary=[
    st.barn?(filterBarns.find(b=>b.id===st.barn)?.name||''):'',
    st.ppl?(filterPpls.find(p=>p.id===st.ppl)?.name||''):'',
    st.assignment?(assignmentCycleLabel(d.assignments,d.assignments.find(a=>a.id===st.assignment))):'',
    st.status||''
  ].filter(Boolean).join(' · ');

  let html='<section class="panel"><div class="rhpp-section-head"><div><h3>Rekap Produksi PPL</h3>'+
    '<p class="muted">'+scopeLabel+' · filter tanggal berdasarkan Chick-In.</p></div></div>'+
    '<form id="productionRecapFilter" class="form-vertical compact-form">'+
      '<label>Pilih Kandang<select name="barn"><option value="">Semua Kandang</option>'+
        filterBarns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+
      '</select></label>'+
      '<label>Pilih PPL<select name="ppl"><option value="">Semua PPL</option>'+
        filterPpls.map(p=>'<option value="'+esc(p.id)+'" '+(st.ppl===p.id?'selected':'')+'>'+esc(p.name)+'</option>').join('')+
      '</select></label>'+
      '<label>Pilih Siklus<select name="assignment"><option value="">Semua Siklus</option>'+
        cycleCandidates.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('')+
      '</select></label>'+
      '<label>Status<select name="status"><option value="">Semua Status</option><option value="PROSES" '+(st.status==='PROSES'?'selected':'')+'>PROSES</option><option value="CLOSED" '+(st.status==='CLOSED'?'selected':'')+'>CLOSED</option></select></label>'+
      '<label>Tanggal Mulai<input type="date" name="from" value="'+esc(from)+'" required></label>'+
      '<label>Tanggal Akhir<input type="date" name="to" value="'+esc(to)+'" required></label>'+
      '<div class="inline-actions"><button type="submit">Tampilkan</button><button type="button" id="productionRecapReset">Reset</button></div>'+
    '</form></section>';

  html+='<div id="productionRecapExportArea" style="display:'+(st.shown?'':'none')+'"><section class="panel">'+
    '<div class="rhpp-section-head"><div><h3>REKAP PRODUKSI</h3><p class="muted">'+prodDateId(from)+' s/d '+prodDateId(to)+(filterSummary?' · '+esc(filterSummary):'')+'</p></div>'+
    '<div class="report-actions"><button type="button" id="productionRecapPrint">Cetak</button><button type="button" id="productionRecapPdf">PDF</button><button type="button" id="productionRecapExcel">Excel</button></div></div>'+
    '<div class="tablewrap"><table style="min-width:1450px"><thead><tr>'+
      '<th>NO</th><th>Kandang / Siklus / Kontrak</th><th>PPL / PIC</th><th>Status</th><th>UMUR</th><th>CHICK IN</th><th>CHICK OUT</th><th>MORT (%)</th><th>TONASE PANEN (Kg)</th><th>Rata2 (Kg)</th><th>PAKAN (Kg)</th><th>FCR</th><th>IP</th>'+
    '</tr></thead><tbody>'+
    rows.map((x,i)=>'<tr>'+
      '<td>'+(i+1)+'</td>'+
      '<td>'+esc(assignmentIdentity(d.assignments,d.barns,d.masters,x.a))+'</td>'+
      '<td>'+esc(x.ppl)+'</td>'+
      '<td>'+esc(x.status)+'</td>'+
      '<td>'+prodFmt(x.age,2)+'</td>'+
      '<td>'+prodFmt(x.chickIn,0)+'</td>'+
      '<td>'+prodFmt(x.chickOut,0)+'</td>'+
      '<td>'+prodFmt(x.mortPct,2)+'</td>'+
      '<td>'+prodFmt(x.kg,2)+'</td>'+
      '<td>'+prodFmt(x.avg,2)+'</td>'+
      '<td>'+prodFmt(x.feed,0)+'</td>'+
      '<td>'+prodFmt(x.fcr,3)+'</td>'+
      '<td>'+prodFmt(x.ip,2)+'</td>'+
    '</tr>').join('')+
    (rows.length?'<tr><th colspan="4">TOTAL</th>'+
      '<th>'+prodFmt(totalAge,2)+'</th>'+
      '<th>'+prodFmt(totals.chickIn,0)+'</th>'+
      '<th>'+prodFmt(totals.chickOut,0)+'</th>'+
      '<th>'+prodFmt(totalMortPct,2)+'</th>'+
      '<th>'+prodFmt(totals.kg,2)+'</th>'+
      '<th>'+prodFmt(totalAvg,2)+'</th>'+
      '<th>'+prodFmt(totals.feed,0)+'</th>'+
      '<th>'+prodFmt(totalFcr,3)+'</th>'+
      '<th>'+prodFmt(totalIp,2)+'</th></tr>':'')+
    '</tbody></table></div>'+(rows.length?'':'<p>Belum ada data sesuai filter.</p>')+
    '</section></div>';

  layout(html);
  const feedErr=feedResponses.find(x=>x?.error)?.error;
  if(d.err||cpr.error||pr.error||fr.error||feedErr)msg((d.err||cpr.error||pr.error||fr.error||feedErr).message);

  const form=document.getElementById('productionRecapFilter');
  if(form){
    const barnSel=form.elements.barn,pplSel=form.elements.ppl,cycleSel=form.elements.assignment;
    const refreshCycles=()=>{
      const barnId=barnSel.value||'',pplId=pplSel.value||'';
      const items=d.assignments.filter(a=>
        (!barnId||a.barn_id===barnId)&&
        (!pplId||a.ppl_id===pplId)
      );
      const current=cycleSel.value;
      cycleSel.innerHTML='<option value="">Semua Siklus</option>'+items.map(a=>'<option value="'+esc(a.id)+'">'+esc(assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('');
      if(items.some(a=>a.id===current))cycleSel.value=current;
    };
    barnSel.onchange=refreshCycles;
    pplSel.onchange=refreshCycles;
    form.onsubmit=async ev=>{
      ev.preventDefault();
      const fd=new FormData(form),f=String(fd.get('from')||''),t=String(fd.get('to')||'');
      if(!f||!t)return msg('Tanggal mulai dan akhir wajib diisi.');
      window.__productionRecapState={
        from:f,to:t,
        barn:String(fd.get('barn')||''),
        ppl:String(fd.get('ppl')||''),
        assignment:String(fd.get('assignment')||''),
        status:String(fd.get('status')||''),
        shown:true
      };
      await productionRecapPage();
    };
    const reset=document.getElementById('productionRecapReset');
    if(reset)reset.onclick=async()=>{
      window.__productionRecapState={from:minDate,to:maxDate,barn:'',ppl:'',assignment:'',status:'',shown:false};
      await productionRecapPage();
    };
  }

  const exportArea=document.getElementById('productionRecapExportArea');
  const exportHtml=()=>{
    const clone=exportArea?.cloneNode(true);if(!clone)return '';
    clone.querySelectorAll('button,.report-actions').forEach(x=>x.remove());
    return '<!doctype html><html><head><meta charset="utf-8"><title>'+esc(fileBase)+'</title>'+
      '<style>@page{size:A4 landscape;margin:6mm}body{font-family:Arial,sans-serif;color:#111;font-size:7.5px}.head{border-bottom:2px solid #111;padding-bottom:6px;margin-bottom:8px}.head h2{margin:0 0 3px;font-size:14px}.head div{font-size:8px}.panel{border:0!important;padding:0!important}.muted{color:#333}table{width:100%;border-collapse:collapse}th,td{border:1px solid #444;padding:3px;text-align:center;white-space:nowrap}th:nth-child(2),td:nth-child(2),th:nth-child(3),td:nth-child(3){text-align:left}.tablewrap{overflow:visible!important}</style></head><body>'+
      '<div class="head">'+'<img src="'+BMS_PRINT_LOGO+'" style="max-height:36px;float:left;margin-right:9px;object-fit:contain">'+
      '<h2>'+esc(company.company_name||company.legal_name||'BAGJASINDO MANDIRI SINDANGKASIH')+'</h2>'+
      (company.address?'<div>'+esc(company.address)+'</div>':'')+
      (company.phone?'<div>Tel/WA: '+esc(company.phone)+'</div>':'')+
      '</div>'+clone.innerHTML+'</body></html>';
  };
  const openPrint=()=>{
    const w=window.open('','_blank');if(!w)return msg('Popup cetak diblokir browser.');
    w.document.write(exportHtml());w.document.close();
    setTimeout(()=>{w.focus();w.print();},450);
  };
  const printBtn=document.getElementById('productionRecapPrint');
  const pdfBtn=document.getElementById('productionRecapPdf');
  const excelBtn=document.getElementById('productionRecapExcel');
  if(printBtn)printBtn.onclick=openPrint;
  if(pdfBtn)pdfBtn.onclick=openPrint;
  if(excelBtn)excelBtn.onclick=()=>{
    const clone=exportArea?.cloneNode(true);if(!clone)return;
    clone.querySelectorAll('button,.report-actions').forEach(x=>x.remove());
    const blob=new Blob(['\ufeff<html><head><meta charset="utf-8"></head><body><h2>'+esc(company.company_name||'BMS Mobile')+'</h2><h3>Rekap Produksi PPL</h3><p>'+prodDateId(from)+' s/d '+prodDateId(to)+(filterSummary?' · '+esc(filterSummary):'')+'</p>'+clone.innerHTML+'</body></html>'],{type:'application/vnd.ms-excel;charset=utf-8'});
    const url=URL.createObjectURL(blob),link=document.createElement('a');
    link.href=url;link.download=fileBase+'.xls';document.body.appendChild(link);link.click();link.remove();
    setTimeout(()=>URL.revokeObjectURL(url),1000);
  };
}
async function pplRhppViewPage(){
  const d=await productionBase();
  const [fr,cpr,sr]=await Promise.all([
    db.from('rhpp_system_final').select('*').order('created_at',{ascending:false}),
    db.from('company_profile').select('company_name,legal_name,address,phone,email,website,logo_url').eq('id',true).maybeSingle(),
    db.rpc('finance_rhpp_summary_v5')
  ]);
  const finals=fr.data||[],company=cpr.data||{},summaries=sr.data||[];
  const barnsForAssignments=[...new Map(d.assignments.map(a=>{
    const b=d.barns.find(x=>x.id===a.barn_id);
    return b?[b.id,b]:null;
  }).filter(Boolean)).values()];
  window.__pplRhppViewState=window.__pplRhppViewState||{barn:'',assignment:''};
  let selectedBarn=window.__pplRhppViewState.barn||'';
  let selectedAssignment=window.__pplRhppViewState.assignment||'';
  const barnAssignments=selectedBarn?d.assignments.filter(a=>a.barn_id===selectedBarn):[];
  if(selectedAssignment&&!barnAssignments.some(a=>a.id===selectedAssignment)){
    selectedAssignment='';
    window.__pplRhppViewState.assignment='';
  }

  let html='<section class="panel"><h3>Lihat RHPP</h3><p class="muted">Pilih kandang, lalu pilih siklus. Data CLOSED ditampilkan sebagai ringkasan RHPP Sistem.</p>'+
    '<form id="pplRhppViewForm" class="form-vertical">'+
      '<label>Kandang<select id="pplRhppBarn" required><option value="">Pilih Kandang</option>'+
        barnsForAssignments.map(b=>'<option value="'+esc(b.id)+'" '+(selectedBarn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+
      '</select></label>'+
      '<label>Siklus<select id="pplRhppCycle" required '+(!selectedBarn?'disabled':'')+'><option value="">Pilih Siklus</option>'+
        barnAssignments.map(a=>'<option value="'+esc(a.id)+'" '+(selectedAssignment===a.id?'selected':'')+'>'+
          esc(assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+
        '</option>').join('')+
      '</select></label>'+
      '<button type="submit">Tampilkan</button>'+
    '</form></section>';

  if(selectedAssignment){
    const a=d.assignments.find(x=>x.id===selectedAssignment);
    const b=d.barns.find(x=>x.id===a?.barn_id);
    const ci=d.chicks.find(x=>x.contract_assignment_id===selectedAssignment);
    const fin=finals.find(x=>x.contract_assignment_id===selectedAssignment);
    const live=summaries.find(x=>x.contract_assignment_id===selectedAssignment);
    const contract=d.masters.find(x=>x.id===a?.master_contract_id);
    const closed=!!fin;
    const src=closed?{
      chick_in_birds:fin.chick_in_birds,
      total_harvest_birds:fin.total_harvest_birds,
      total_harvest_kg:fin.total_harvest_kg,
      avg_bw_kg:fin.avg_bw_kg,
      weighted_age:fin.weighted_age,
      mortality_pct:fin.mortality_pct,
      net_feed_kg:fin.net_feed_kg,
      fcr_actual:fin.fcr_actual,
      fcr_standard:fin.fcr_standard,
      ip:fin.ip,
      harvest_value:fin.harvest_value,
      main_doc_cost:fin.main_doc_cost,
      main_feed_cost:fin.main_feed_cost,
      main_return_cost:fin.main_return_cost,
      sapronak_cost:fin.sapronak_cost,
      base_profit:fin.base_profit,
      bonus_ip_rate:fin.bonus_ip_rate,
      bonus_ip:fin.bonus_ip,
      bonus_fc_rate:fin.bonus_fc_rate,
      bonus_fc:fin.bonus_fc,
      bonus_mortality_rate:fin.bonus_depletion_rate,
      bonus_mortality:fin.bonus_depletion,
      farmer_profit:fin.system_amount,
      profit_per_chick_in:fin.profit_per_chick_in,
      std_bw_kg:fin.std_bw_kg
    }:live;

    const chickIn=prodNum(src?.chick_in_birds||((ci?.received||0)-(ci?.doa||0)));
    const harvestBirds=prodNum(src?.total_harvest_birds);
    const harvestKg=prodNum(src?.total_harvest_kg);
    const avgBw=prodNum(src?.avg_bw_kg);
    const feedKg=prodNum(src?.net_feed_kg);
    const feedPerBird=chickIn>0?feedKg*1000/chickIn:0;
    const avgLivePrice=harvestKg>0?prodNum(src?.harvest_value)/harvestKg:0;
    const docUnitPrice=chickIn>0?prodNum(src?.main_doc_cost)/chickIn:prodNum(contract?.doc_price);
    const feedUnitPrice=feedKg>0?prodNum(src?.main_feed_cost)/feedKg:0;
    const val=(label,value)=>'<div class="rhpp-mini-row"><span>'+esc(label)+'</span><strong>'+value+'</strong></div>';
    const money=v=>'Rp '+prodFmt(v,0);

    html+='<div id="pplRhppExportArea">'+
      '<section class="panel rhpp-mini-sheet">'+
        '<div class="rhpp-section-head"><div><h3>'+esc(assignmentIdentity(d.assignments,d.barns,d.masters,a))+'</h3>'+
          '<p class="muted">'+assignmentCycleLabel(d.assignments,a)+' · '+(closed?'CLOSED / FINAL':'PROSES')+(fin?' · Close '+prodDateId(fin.closed_on):'')+'</p></div>'+
          '<div class="report-actions"><button type="button" id="pplRhppPrint">Print</button><button type="button" id="pplRhppPdf">PDF</button><button type="button" id="pplRhppExcel">Excel</button></div>'+
        '</div>'+
        '<div class="rhpp-mini-grid">'+
          '<div class="rhpp-mini-block"><h4>INPUT WAJIB</h4>'+
            val('Nama Kandang / Peternak',esc(b?shortBarnLabel(b):'-'))+
            val('Tanggal Chick-In',prodDateId(closed?fin?.chick_in_date:ci?.arrived_on))+
            val('DOC Masuk (Ekor)',prodFmt(chickIn,0))+
            val('FCR Standar',prodFmt(src?.fcr_standard,3))+
            val('BW Standar (Kg)',src?.std_bw_kg!=null?prodFmt(src.std_bw_kg,3):'-')+
            val('Tarif Bonus Mortalitas (Rp/Kg)',money(src?.bonus_mortality_rate))+
            val('Status Bonus FC',prodNum(src?.bonus_fc)>0?'DAPAT BONUS':'TIDAK ADA BONUS')+
          '</div>'+
          '<div class="rhpp-mini-block"><h4>KINERJA PRODUKSI</h4>'+
            val('Mortalitas',prodFmt(src?.mortality_pct,2)+' %')+
            val('Bobot Badan',prodFmt(avgBw,3)+' Kg')+
            val('Total Pakan',prodFmt(feedKg,2)+' Kg')+
            val('Pakan Per Ekor',prodFmt(feedPerBird,0)+' gr/ekor')+
            val('Umur Panen',prodFmt(src?.weighted_age,2)+' hari')+
            val('FCR',prodFmt(src?.fcr_actual,3))+
            val('Indek Prestasi',prodFmt(src?.ip,2))+
          '</div>'+
          '<div class="rhpp-mini-block"><h4>RINGKASAN DATA</h4>'+
            val('Total Panen (Ekor)',prodFmt(harvestBirds,0))+
            val('Total Berat (Kg)',prodFmt(harvestKg,2))+
            val('Rata-rata BB (Kg/Ekor)',prodFmt(avgBw,3))+
            val('Pakan Bersih (Kg)',prodFmt(feedKg,2))+
            val('Harga DOC (Rp/Ekor)',money(docUnitPrice))+
            val('Harga Pakan (Rp/Kg)',money(feedUnitPrice))+
            val('Harga Bersih (Rp/Kg)',money(avgLivePrice))+
            val('Tarif Bonus IP (Rp/Kg)',money(src?.bonus_ip_rate))+
            val('Tarif Bonus FC (Rp/Kg)',money(src?.bonus_fc_rate))+
            val('FCR Final',prodFmt(src?.fcr_actual,3))+
          '</div>'+
          '<div class="rhpp-mini-block rhpp-mini-value"><h4>NILAI RHPP</h4>'+
            val('Jml. Sapronak',money(src?.sapronak_cost))+
            val('Jml. Retur',money(src?.main_return_cost))+
            val('Total Sapronak',money(src?.sapronak_cost))+
            val('Total Hasil Produksi',money(src?.harvest_value))+
            val('Laba',money(src?.base_profit))+
            val('Bonus IP',money(src?.bonus_ip))+
            val('Bonus FC',money(src?.bonus_fc))+
            val('Bonus Mortalitas',money(src?.bonus_mortality))+
            val('Laba Peternak',money(src?.farmer_profit))+
            val('Laba Per Ekor',money(src?.profit_per_chick_in))+
          '</div>'+
        '</div>'+
        (!src?'<p class="muted">Ringkasan RHPP belum tersedia untuk siklus ini.</p>':'')+
        (!closed?'<p class="muted">Periode masih PROSES. Nilai FINAL tersedia setelah Administrator melakukan Close.</p>':'')+
      '</section></div>';
  }

  layout(html);
  if(d.err||fr.error||cpr.error||sr.error)msg((d.err||fr.error||cpr.error||sr.error).message);
  const barnSel=document.getElementById('pplRhppBarn');
  const cycleSel=document.getElementById('pplRhppCycle');
  if(barnSel)barnSel.onchange=async()=>{
    window.__pplRhppViewState={barn:barnSel.value||'',assignment:''};
    await pplRhppViewPage();
  };
  const form=document.getElementById('pplRhppViewForm');
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();
    if(!barnSel?.value)return msg('Pilih kandang.');
    if(!cycleSel?.value)return msg('Pilih siklus.');
    window.__pplRhppViewState={barn:barnSel.value,assignment:cycleSel.value};
    await pplRhppViewPage();
  };

  if(selectedAssignment){
    const exportArea=document.getElementById('pplRhppExportArea');
    const a=d.assignments.find(x=>x.id===selectedAssignment);
    const b=d.barns.find(x=>x.id===a?.barn_id);
    const fileBase=('RHPP_'+(b?.code||'Kandang')+'_'+String(a?.start_date||'Siklus')).replace(/[^A-Za-z0-9_-]+/g,'_');
    const docHtml=()=>{
      const clone=exportArea?.cloneNode(true);if(!clone)return '';
      clone.querySelectorAll('button,.report-actions').forEach(x=>x.remove());
      return '<!doctype html><html><head><meta charset="utf-8"><title>'+esc(fileBase)+'</title>'+
        '<style>@page{size:A4 landscape;margin:9mm}body{font-family:Arial,sans-serif;color:#111;font-size:9px}.head{border-bottom:2px solid #111;padding-bottom:7px;margin-bottom:10px}.head h2{margin:0 0 3px;font-size:15px}.head div{font-size:9px}.panel{border:0!important;padding:0!important}.muted{color:#444}.rhpp-mini-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px}.rhpp-mini-block{border:1px solid #aaa}.rhpp-mini-block h4{margin:0;padding:5px 7px;background:#eee;font-size:10px}.rhpp-mini-row{display:grid;grid-template-columns:1.5fr 1fr;border-top:1px solid #ddd;padding:4px 6px;gap:6px}.rhpp-mini-row span{color:#333}.rhpp-mini-row strong{text-align:right}</style></head><body>'+
        '<div class="head">'+(company.logo_url?'<img src="'+esc(company.logo_url)+'" style="max-height:38px;float:left;margin-right:10px">':'')+
        '<h2>'+esc(company.company_name||company.legal_name||'BAGJASINDO MANDIRI SINDANGKASIH')+'</h2>'+
        (company.address?'<div>'+esc(company.address)+'</div>':'')+
        (company.phone?'<div>Tel/WA: '+esc(company.phone)+'</div>':'')+
        '</div><h2>RHPP Sistem</h2>'+clone.innerHTML+'</body></html>';
    };
    const openPrint=()=>{
      const w=window.open('','_blank');if(!w)return msg('Popup cetak diblokir browser.');
      w.document.write(docHtml());w.document.close();
      setTimeout(()=>{w.focus();w.print();},450);
    };
    const pBtn=document.getElementById('pplRhppPrint');
    const pdfBtn=document.getElementById('pplRhppPdf');
    const xBtn=document.getElementById('pplRhppExcel');
    if(pBtn)pBtn.onclick=openPrint;
    if(pdfBtn)pdfBtn.onclick=openPrint;
    if(xBtn)xBtn.onclick=()=>{
      const clone=exportArea?.cloneNode(true);if(!clone)return;
      clone.querySelectorAll('button,.report-actions').forEach(x=>x.remove());
      const blob=new Blob(['\ufeff<html><head><meta charset="utf-8"></head><body><h2>'+esc(company.company_name||'BMS Mobile')+'</h2><h3>RHPP Sistem</h3>'+clone.innerHTML+'</body></html>'],{type:'application/vnd.ms-excel;charset=utf-8'});
      const url=URL.createObjectURL(blob),link=document.createElement('a');
      link.href=url;link.download=fileBase+'.xls';document.body.appendChild(link);link.click();link.remove();
      setTimeout(()=>URL.revokeObjectURL(url),1000);
    };
  }
}

async function adminRhppHistoryPage(){
  const d=await productionBase();
  const [fr,cpr,sr,hdr,shr,shir,rrr,rir,itr,ctr]=await Promise.all([
    db.from('rhpp_system_final').select('*').order('created_at',{ascending:false}),
    db.from('company_profile').select('company_name,legal_name,address,phone,email,website,logo_url').eq('id',true).maybeSingle(),
    db.rpc('finance_rhpp_summary_v5'),
    db.from('marketing_contract_harvests').select('id,contract_assignment_id,harvested_on,birds,net_weight_kg,avg_weight_kg,price_per_kg,total_amount,buyer_name,vehicle_number').order('harvested_on',{ascending:true}),
    db.from('logistics_shipments').select('id,contract_assignment_id,shipment_date'),
    db.from('logistics_shipment_items').select('shipment_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('logistics_returns').select('id,contract_assignment_id,return_date,reference,notes'),
    db.from('logistics_return_items').select('return_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('items').select('id,name,feed_phase,unit,kg_per_unit').eq('category','PAKAN'),
    db.from('contracts').select('id,number,doc_price,pre_starter_price,starter_price,finisher_price').is('cycle_id',null)
  ]);
  const finals=fr.data||[],company=cpr.data||{},summaries=sr.data||[];
  const harvestDetails=hdr.data||[],shipments=shr.data||[],shipmentItems=shir.data||[];
  const returns=rrr.data||[],returnItems=rir.data||[],printFeedItems=itr.data||[],printContracts=ctr.data||[];
  const historyOnly=true;
  const viewAssignments=d.assignments.filter(a=>finals.some(f=>f.contract_assignment_id===a.id));
  const barnsForAssignments=[...new Map(viewAssignments.map(a=>{
    const b=d.barns.find(x=>x.id===a.barn_id);
    return b?[b.id,b]:null;
  }).filter(Boolean)).values()];
  window.__adminRhppHistoryState=window.__adminRhppHistoryState||{barn:'',assignment:''};
  let selectedBarn=window.__adminRhppHistoryState.barn||'';
  let selectedAssignment=window.__adminRhppHistoryState.assignment||'';
  const barnAssignments=selectedBarn?viewAssignments.filter(a=>a.barn_id===selectedBarn):[];
  if(selectedAssignment&&!barnAssignments.some(a=>a.id===selectedAssignment)){
    selectedAssignment='';
    window.__adminRhppHistoryState.assignment='';
  }

  let html='<section class="panel"><h3>'+(historyOnly?'Riwayat RHPP':'Lihat RHPP')+'</h3><p class="muted">'+(historyOnly?'Pilih kandang dan siklus CLOSED. Riwayat memakai snapshot RHPP Sistem Final saat produksi ditutup dan hanya untuk dilihat/cetak.':'Pilih kandang, lalu pilih siklus. Data CLOSED ditampilkan sebagai ringkasan RHPP Sistem.')+'</p>'+
    '<form id="pplRhppViewForm" class="form-vertical">'+
      '<label>Kandang<select id="pplRhppBarn" required><option value="">Pilih Kandang</option>'+
        barnsForAssignments.map(b=>'<option value="'+esc(b.id)+'" '+(selectedBarn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+
      '</select></label>'+
      '<label>Siklus<select id="pplRhppCycle" required '+(!selectedBarn?'disabled':'')+'><option value="">Pilih Siklus</option>'+
        barnAssignments.map(a=>'<option value="'+esc(a.id)+'" '+(selectedAssignment===a.id?'selected':'')+'>'+
          esc(assignmentCycleLabel(d.assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+
        '</option>').join('')+
      '</select></label>'+
      '<button type="submit">Tampilkan</button>'+
    '</form></section>';

  if(selectedAssignment){
    const a=d.assignments.find(x=>x.id===selectedAssignment);
    const b=d.barns.find(x=>x.id===a?.barn_id);
    const ci=d.chicks.find(x=>x.contract_assignment_id===selectedAssignment);
    const fin=finals.find(x=>x.contract_assignment_id===selectedAssignment);
    const live=summaries.find(x=>x.contract_assignment_id===selectedAssignment);
    const contract=d.masters.find(x=>x.id===a?.master_contract_id);
    const closed=!!fin;
    const src=closed?{
      chick_in_birds:fin.chick_in_birds,
      total_harvest_birds:fin.total_harvest_birds,
      total_harvest_kg:fin.total_harvest_kg,
      avg_bw_kg:fin.avg_bw_kg,
      weighted_age:fin.weighted_age,
      mortality_pct:fin.mortality_pct,
      net_feed_kg:fin.net_feed_kg,
      fcr_actual:fin.fcr_actual,
      fcr_standard:fin.fcr_standard,
      ip:fin.ip,
      harvest_value:fin.harvest_value,
      main_doc_cost:fin.main_doc_cost,
      main_feed_cost:fin.main_feed_cost,
      main_return_cost:fin.main_return_cost,
      sapronak_cost:fin.sapronak_cost,
      base_profit:fin.base_profit,
      bonus_ip_rate:fin.bonus_ip_rate,
      bonus_ip:fin.bonus_ip,
      bonus_fc_rate:fin.bonus_fc_rate,
      bonus_fc:fin.bonus_fc,
      bonus_mortality_rate:fin.bonus_depletion_rate,
      bonus_mortality:fin.bonus_depletion,
      farmer_profit:fin.system_amount,
      profit_per_chick_in:fin.profit_per_chick_in,
      std_bw_kg:fin.std_bw_kg
    }:live;

    const chickIn=prodNum(src?.chick_in_birds||((ci?.received||0)-(ci?.doa||0)));
    const harvestBirds=prodNum(src?.total_harvest_birds);
    const harvestKg=prodNum(src?.total_harvest_kg);
    const avgBw=prodNum(src?.avg_bw_kg);
    const feedKg=prodNum(src?.net_feed_kg);
    const feedPerBird=chickIn>0?feedKg*1000/chickIn:0;
    const avgLivePrice=harvestKg>0?prodNum(src?.harvest_value)/harvestKg:0;
    const docUnitPrice=chickIn>0?prodNum(src?.main_doc_cost)/chickIn:prodNum(contract?.doc_price);
    const feedUnitPrice=feedKg>0?prodNum(src?.main_feed_cost)/feedKg:0;
    const val=(label,value)=>'<div class="rhpp-mini-row"><span>'+esc(label)+'</span><strong>'+value+'</strong></div>';
    const money=v=>'Rp '+prodFmt(v,0);

    html+='<div id="pplRhppExportArea">'+
      '<section class="panel rhpp-mini-sheet">'+
        '<div class="rhpp-section-head"><div><h3>'+esc(assignmentIdentity(d.assignments,d.barns,d.masters,a))+'</h3>'+
          '<p class="muted">'+assignmentCycleLabel(d.assignments,a)+' · '+(closed?'CLOSED / FINAL':'PROSES')+(fin?' · Close '+prodDateId(fin.closed_on):'')+'</p></div>'+
          '<div class="report-actions"><button type="button" id="pplRhppPrint">Print</button><button type="button" id="pplRhppPdf">PDF</button><button type="button" id="pplRhppExcel">Excel</button></div>'+
        '</div>'+
        '<div class="rhpp-mini-grid">'+
          '<div class="rhpp-mini-block"><h4>INPUT WAJIB</h4>'+
            val('Nama Kandang / Peternak',esc(b?shortBarnLabel(b):'-'))+
            val('Tanggal Chick-In',prodDateId(closed?fin?.chick_in_date:ci?.arrived_on))+
            val('DOC Masuk (Ekor)',prodFmt(chickIn,0))+
            val('FCR Standar',prodFmt(src?.fcr_standard,3))+
            val('BW Standar (Kg)',src?.std_bw_kg!=null?prodFmt(src.std_bw_kg,3):'-')+
            val('Tarif Bonus Mortalitas (Rp/Kg)',money(src?.bonus_mortality_rate))+
            val('Status Bonus FC',prodNum(src?.bonus_fc)>0?'DAPAT BONUS':'TIDAK ADA BONUS')+
          '</div>'+
          '<div class="rhpp-mini-block"><h4>KINERJA PRODUKSI</h4>'+
            val('Mortalitas',prodFmt(src?.mortality_pct,2)+' %')+
            val('Bobot Badan',prodFmt(avgBw,3)+' Kg')+
            val('Total Pakan',prodFmt(feedKg,2)+' Kg')+
            val('Pakan Per Ekor',prodFmt(feedPerBird,0)+' gr/ekor')+
            val('Umur Panen',prodFmt(src?.weighted_age,2)+' hari')+
            val('FCR',prodFmt(src?.fcr_actual,3))+
            val('Indek Prestasi',prodFmt(src?.ip,2))+
          '</div>'+
          '<div class="rhpp-mini-block"><h4>RINGKASAN DATA</h4>'+
            val('Total Panen (Ekor)',prodFmt(harvestBirds,0))+
            val('Total Berat (Kg)',prodFmt(harvestKg,2))+
            val('Rata-rata BB (Kg/Ekor)',prodFmt(avgBw,3))+
            val('Pakan Bersih (Kg)',prodFmt(feedKg,2))+
            val('Harga DOC (Rp/Ekor)',money(docUnitPrice))+
            val('Harga Pakan (Rp/Kg)',money(feedUnitPrice))+
            val('Harga Bersih (Rp/Kg)',money(avgLivePrice))+
            val('Tarif Bonus IP (Rp/Kg)',money(src?.bonus_ip_rate))+
            val('Tarif Bonus FC (Rp/Kg)',money(src?.bonus_fc_rate))+
            val('FCR Final',prodFmt(src?.fcr_actual,3))+
          '</div>'+
          '<div class="rhpp-mini-block rhpp-mini-value"><h4>NILAI RHPP</h4>'+
            val('Jml. Sapronak',money(src?.sapronak_cost))+
            val('Jml. Retur',money(src?.main_return_cost))+
            val('Total Sapronak',money(src?.sapronak_cost))+
            val('Total Hasil Produksi',money(src?.harvest_value))+
            val('Laba',money(src?.base_profit))+
            val('Bonus IP',money(src?.bonus_ip))+
            val('Bonus FC',money(src?.bonus_fc))+
            val('Bonus Mortalitas',money(src?.bonus_mortality))+
            val('Laba Peternak',money(src?.farmer_profit))+
            val('Laba Per Ekor',money(src?.profit_per_chick_in))+
          '</div>'+
        '</div>'+
        (!src?'<p class="muted">Ringkasan RHPP belum tersedia untuk siklus ini.</p>':'')+
        (!closed?'<p class="muted">Periode masih PROSES. Nilai FINAL tersedia setelah Administrator melakukan Close.</p>':'')+
      '</section></div>';
  }

  layout(html);
  if(d.err||fr.error||cpr.error||sr.error||hdr.error||shr.error||shir.error||rrr.error||rir.error||itr.error||ctr.error)msg((d.err||fr.error||cpr.error||sr.error||hdr.error||shr.error||shir.error||rrr.error||rir.error||itr.error||ctr.error).message);
  const barnSel=document.getElementById('pplRhppBarn');
  const cycleSel=document.getElementById('pplRhppCycle');
  if(barnSel)barnSel.onchange=async()=>{
    window.__adminRhppHistoryState={barn:barnSel.value||'',assignment:''};
    await adminRhppHistoryPage();
  };
  const form=document.getElementById('pplRhppViewForm');
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();
    if(!barnSel?.value)return msg('Pilih kandang.');
    if(!cycleSel?.value)return msg('Pilih siklus.');
    window.__adminRhppHistoryState={barn:barnSel.value,assignment:cycleSel.value};
    await adminRhppHistoryPage();
  };

  if(selectedAssignment){
    const exportArea=document.getElementById('pplRhppExportArea');
    const a=d.assignments.find(x=>x.id===selectedAssignment);
    const b=d.barns.find(x=>x.id===a?.barn_id);
    const fileBase=('RHPP_'+(b?.code||'Kandang')+'_'+String(a?.start_date||'Siklus')).replace(/[^A-Za-z0-9_-]+/g,'_');
    const docHtml=()=>{
      const fin=finals.find(x=>x.contract_assignment_id===selectedAssignment);
      const live=summaries.find(x=>x.contract_assignment_id===selectedAssignment);
      const ci=d.chicks.find(x=>x.contract_assignment_id===selectedAssignment);
      const contract=printContracts.find(x=>x.id===a?.master_contract_id)||d.masters.find(x=>x.id===a?.master_contract_id)||{};
      const src=fin||live||{};
      const hs=harvestDetails.filter(h=>h.contract_assignment_id===selectedAssignment).slice().sort((u,v)=>String(u.harvested_on||'').localeCompare(String(v.harvested_on||'')));
      const chickIn=prodNum(src.chick_in_birds||((ci?.received||0)-(ci?.doa||0)));
      const feedKg=prodNum(src.net_feed_kg);
      const docPrice=chickIn>0?prodNum(src.main_doc_cost)/chickIn:prodNum(contract?.doc_price);
      const harvestBirds=prodNum(src.total_harvest_birds);
      const harvestKg=prodNum(src.total_harvest_kg);
      const avgBw=prodNum(src.avg_bw_kg);
      const feedPerBird=chickIn>0?feedKg*1000/chickIn:0;
      const avgLivePrice=harvestKg>0?prodNum(src.harvest_value)/harvestKg:0;
      const fcrDiff=prodNum(src.fcr_standard)-prodNum(src.fcr_actual);
      const companyName=company.company_name||company.legal_name||'Bagjasindo Mandiri Sindangkasih';
      const companyContact=[company.address,company.phone?('Tel/WA: '+company.phone):'',company.email||'',company.website||''].filter(Boolean).map(esc).join('<br>');
      const rawLogo=String(company.logo_url||'').trim();
      const logoSrc=rawLogo.startsWith('data:image/')&&rawLogo.includes(',')
        ?rawLogo+'='.repeat((4-(rawLogo.split(',')[1].length%4))%4)
        :rawLogo;
      const logo='<div class="brand-logo">'+(logoSrc?'<img class="logo" src="'+esc(logoSrc)+'" alt="Logo BMS">':'<div class="logo-mark">BMS</div>')+'</div>';
      const printStamp=new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',dateStyle:'medium',timeStyle:'short'}).format(new Date())+' WIB';
      const money=v=>prodFmt(v,0);
      const n2=v=>prodFmt(v,2);
      const priceForPhase=phase=>{
        const p=String(phase||'').toUpperCase();
        if(p==='PRE_STARTER')return prodNum(contract.pre_starter_price);
        if(p==='STARTER')return prodNum(contract.starter_price);
        if(p==='FINISHER')return prodNum(contract.finisher_price);
        return 0;
      };
      const phaseLabel=phase=>{
        const p=String(phase||'').toUpperCase();
        if(p==='PRE_STARTER')return 'Pre Starter';
        if(p==='STARTER')return 'Starter';
        if(p==='FINISHER')return 'Finisher';
        return phase||'Suplayer Lain';
      };

      const assignmentShipIds=new Set(shipments.filter(x=>x.contract_assignment_id===selectedAssignment).map(x=>x.id));
      const assignmentReturnIds=new Set(returns.filter(x=>x.contract_assignment_id===selectedAssignment).map(x=>x.id));
      const feedMap=new Map();
      const ensureFeed=item=>{
        const key=item?.id||'OTHER';
        if(!feedMap.has(key))feedMap.set(key,{item,inside:0,insideKg:0,ret:0,retKg:0});
        return feedMap.get(key);
      };
      shipmentItems.filter(x=>assignmentShipIds.has(x.shipment_id)).forEach(x=>{
        const item=printFeedItems.find(i=>i.id===x.item_id);
        const row=ensureFeed(item);
        row.inside+=prodNum(x.quantity);
        row.insideKg+=prodNum(x.quantity_kg)||prodNum(x.quantity)*prodNum(item?.kg_per_unit);
      });
      returnItems.filter(x=>assignmentReturnIds.has(x.return_id)).forEach(x=>{
        const item=printFeedItems.find(i=>i.id===x.item_id);
        const row=ensureFeed(item);
        row.ret+=prodNum(x.quantity);
        row.retKg+=prodNum(x.quantity_kg)||prodNum(x.quantity)*prodNum(item?.kg_per_unit);
      });
      const preferred=['PRE_STARTER','STARTER','FINISHER'];
      const feedRows=[...feedMap.values()].sort((x,y)=>{
        const ax=preferred.indexOf(String(x.item?.feed_phase||'').toUpperCase());
        const ay=preferred.indexOf(String(y.item?.feed_phase||'').toUpperCase());
        return (ax<0?99:ax)-(ay<0?99:ay)||String(x.item?.name||'').localeCompare(String(y.item?.name||''));
      });
      const totalFeedBags=feedRows.reduce((n,x)=>n+Math.max(0,x.inside-x.ret),0);

      const returnRows=returnItems.filter(x=>assignmentReturnIds.has(x.return_id)).map(x=>{
        const ret=returns.find(r=>r.id===x.return_id);
        const item=printFeedItems.find(i=>i.id===x.item_id);
        const kg=prodNum(x.quantity_kg)||prodNum(x.quantity)*prodNum(item?.kg_per_unit);
        const price=priceForPhase(item?.feed_phase)||prodNum(x.unit_price);
        return {ret,item,zak:prodNum(x.quantity),kg,price,value:kg*price};
      });

      const kv=(label,value)=>'<div class="kv"><span>'+esc(label)+'</span><b>:</b><strong>'+value+'</strong></div>';
      const header='<header class="head">'+logo+
        '<div class="company"><h1>'+esc(companyName)+'</h1><p>Integritas Kemitraan untuk Peternakan Lebih Baik</p></div>'+
        '<div class="contact"><strong>DOKUMEN RHPP FINAL</strong><br>'+companyContact+'</div></header>'+
        '<div class="doc-title"><h2>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</h2><p>'+
        esc(b?shortBarnLabel(b):'-')+' &nbsp; · &nbsp; '+esc(assignmentCycleLabel(d.assignments,a))+' &nbsp; · &nbsp; FINAL / CLOSED</p></div>';

      return '<!doctype html><html><head><meta charset="utf-8"><title>'+esc(fileBase)+'</title>'+
        '<style>'+
        '@page{size:A4 landscape;margin:7mm}*{box-sizing:border-box}html,body{margin:0;padding:0;font-family:Arial,Helvetica,sans-serif;color:#15253b;font-size:8.4px;line-height:1.18;-webkit-print-color-adjust:exact!important;print-color-adjust:exact!important}.page{min-height:190mm;position:relative;padding-bottom:9mm}.page+.page{page-break-before:always}.head{display:grid;grid-template-columns:64px 1fr 290px;gap:12px;align-items:center;border-bottom:3px solid #174d88;padding:3px 2px 7px;margin-bottom:5px}.brand-logo{width:58px;height:48px;display:flex;align-items:center;justify-content:center}.logo{max-width:58px;max-height:48px;object-fit:contain;display:block}.logo-mark{width:48px;height:48px;border:2px solid #174d88;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:900;color:#174d88}.company h1{font-size:17px;margin:0;color:#103b70;font-weight:800}.company p{margin:2px 0 0;color:#63758b;font-size:7.7px}.contact{text-align:right;color:#40536c;font-size:7.2px;line-height:1.35}.doc-title{text-align:center;margin:5px 0 7px}.doc-title h2{font-size:17px;margin:0;color:#102e57;font-weight:800}.doc-title p{margin:2px 0 0;font-size:8px;color:#52667f;font-weight:700}.band{background:#255a8b!important;color:#fff!important;text-align:center;font-size:12px;font-weight:800;padding:4px 7px;letter-spacing:.2px;margin:5px 0 4px}.subband{background:#5b9bd5!important;color:#fff!important;font-size:9px;font-weight:800;padding:4px 6px;margin:6px 0 3px}.tbl{width:100%;border-collapse:collapse;table-layout:fixed}.tbl th{background:#5b9bd5!important;color:#fff!important;border:1px solid #d6e0e8;padding:3px 3px;text-align:center;font-weight:700}.tbl td{border:1px solid #d7dde4;padding:2.4px 3px;color:#15253b}.tbl .n{text-align:right}.tbl .c{text-align:center}.tbl .total th,.tbl .total td{background:#e2f0d9!important;color:#122a18!important;font-weight:800}.feed-table th{font-size:7.7px}.return-wrap{width:48%;margin-top:4px}.summary-grid{display:grid;grid-template-columns:1fr 1fr;gap:13px 28px;margin-top:7px}.summary-block h3{margin:0 0 4px;background:#e2e2e2!important;color:#111;padding:3px 6px;font-size:10px;font-weight:500}.kv{display:grid;grid-template-columns:190px 10px 1fr;min-height:17px;align-items:center;font-size:9px}.kv strong{font-weight:600}.rhpp-value strong{font-weight:800}.footer{position:absolute;left:0;right:0;bottom:0;border-top:1px solid #d8e0e8;padding-top:3px;display:flex;justify-content:space-between;color:#68788b;font-size:6.8px}.page2-head{margin-bottom:8px}.status-badge{display:inline-block;padding:2px 6px;border-radius:4px;background:#d7f4e4!important;color:#145c3b!important;font-weight:800}'+
        '</style></head><body>'+

        '<section class="page">'+header+
          '<div class="band">DATA PANEN</div>'+
          '<table class="tbl"><thead><tr>'+
            '<th style="width:11%">Tanggal</th><th style="width:16%">Pembeli / RPA</th><th style="width:13%">No. Kendaraan</th><th style="width:9%">Ekor</th><th style="width:12%">Berat (Kg)</th><th style="width:8%">BW</th><th style="width:12%">Harga Kontrak</th><th style="width:19%">Nilai Produksi (Rp)</th>'+
          '</tr></thead><tbody>'+
          hs.map(h=>'<tr>'+
            '<td class="c">'+prodDateId(h.harvested_on)+'</td>'+
            '<td>'+esc(h.buyer_name||'-')+'</td>'+
            '<td>'+esc(h.vehicle_number||'-')+'</td>'+
            '<td class="n">'+prodFmt(h.birds,0)+'</td>'+
            '<td class="n">'+n2(h.net_weight_kg)+'</td>'+
            '<td class="n">'+n2(h.avg_weight_kg)+'</td>'+
            '<td class="n">'+money(h.price_per_kg)+'</td>'+
            '<td class="n">'+money(h.total_amount)+'</td>'+
          '</tr>').join('')+
          '<tr class="total"><th colspan="3" style="text-align:left">TOTAL</th><td class="n">'+prodFmt(harvestBirds,0)+'</td><td class="n">'+n2(harvestKg)+'</td><td class="n">'+n2(avgBw)+'</td><td></td><td class="n">'+money(src.harvest_value)+'</td></tr>'+
          '</tbody></table>'+

          '<div class="band">PEMAKAIAN PAKAN &amp; RETUR</div>'+
          '<table class="tbl feed-table"><thead><tr>'+
            '<th style="width:20%">Jenis</th><th style="width:10%">Masuk (Zak)</th><th style="width:10%">Retur (Zak)</th><th style="width:10%">Bersih (Zak)</th><th style="width:10%">Kg/Zak</th><th style="width:12%">Bersih (Kg)</th><th style="width:13%">Harga Kontrak (Rp/Kg)</th><th style="width:15%">Nilai Bersih (Rp)</th>'+
          '</tr></thead><tbody>'+
          (feedRows.length?feedRows.map(x=>{
            const cleanZak=Math.max(0,x.inside-x.ret);
            const cleanKg=Math.max(0,x.insideKg-x.retKg);
            const kgPerZak=prodNum(x.item?.kg_per_unit)||(cleanZak?cleanKg/cleanZak:0);
            const price=priceForPhase(x.item?.feed_phase);
            return '<tr><td>'+esc(phaseLabel(x.item?.feed_phase)||x.item?.name||'Pakan')+'</td>'+
              '<td class="n">'+n2(x.inside)+'</td><td class="n">'+n2(x.ret)+'</td><td class="n">'+n2(cleanZak)+'</td>'+
              '<td class="n">'+n2(kgPerZak)+'</td><td class="n">'+n2(cleanKg)+'</td><td class="n">'+money(price)+'</td><td class="n">'+money(cleanKg*price)+'</td></tr>';
          }).join(''):'<tr><td colspan="8" class="c">Tidak ada rincian pakan.</td></tr>')+
          '<tr class="total"><th colspan="3" style="text-align:left">TOTAL BERSIH</th><td class="n">'+n2(totalFeedBags)+'</td><td></td><td class="n">'+n2(feedKg)+'</td><td></td><td class="n">'+money(src.main_feed_cost)+'</td></tr>'+
          '</tbody></table>'+

          '<div class="return-wrap"><div class="subband">KETERANGAN RETUR</div>'+
          '<table class="tbl"><thead><tr><th>Keterangan Retur</th><th style="width:18%">Zak</th><th style="width:22%">Kg</th><th style="width:28%">Nilai Retur (Rp)</th></tr></thead><tbody>'+
          (returnRows.length?returnRows.map(x=>'<tr><td>'+esc((x.ret?.notes||x.ret?.reference||phaseLabel(x.item?.feed_phase)||x.item?.name||'Retur Pakan'))+'</td><td class="n">'+n2(x.zak)+'</td><td class="n">'+n2(x.kg)+'</td><td class="n">'+money(x.value)+'</td></tr>').join(''):'<tr><td>Retur Pakan</td><td class="n">-</td><td class="n">-</td><td class="n">'+money(src.main_return_cost)+'</td></tr>')+
          '</tbody></table></div>'+
          '<footer class="footer"><div><strong>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</strong><br>'+esc(companyName)+'</div><div style="text-align:right"><strong>Halaman 1 dari 2</strong><br>Dicetak: '+esc(printStamp)+'</div></footer>'+
        '</section>'+

        '<section class="page">'+header+
          '<div class="summary-grid">'+
            '<div class="summary-block"><h3>INPUT WAJIB</h3>'+
              kv('Nama Kandang / Peternak',esc(b?shortBarnLabel(b):'-'))+
              kv('Tanggal Chick-in',fin?.chick_in_date?prodDateId(fin.chick_in_date):(ci?.arrived_on?prodDateId(ci.arrived_on):'-'))+
              kv('DOC Masuk (Ekor)',prodFmt(chickIn,0))+
              kv('FCR Standar (Otomatis)',prodFmt(src.fcr_standard,3))+
              kv('BW Standar (Kg)',src.std_bw_kg!=null?prodFmt(src.std_bw_kg,3):'-')+
              kv('Tarif Bonus Mortalitas (Rp/Kg)',money(src.bonus_depletion_rate||src.bonus_mortality_rate))+
              kv('Status Bonus FC',prodNum(src.bonus_fc)>0?'DAPAT BONUS':'TIDAK ADA BONUS')+
            '</div>'+
            '<div class="summary-block"><h3>KINERJA PRODUKSI</h3>'+
              kv('Mortalitas',prodFmt(src.mortality_pct,2)+' %')+
              kv('Bobot Badan',prodFmt(avgBw,2)+' Kg')+
              kv('Total Pakan',n2(feedKg)+' Kg')+
              kv('Pakan Per Ekor',prodFmt(feedPerBird,0)+' gr/ekor')+
              kv('Umur Panen',prodFmt(src.weighted_age,2)+' hari')+
              kv('FCR',prodFmt(src.fcr_actual,3))+
              kv('Indek Prestasi',prodFmt(src.ip,2))+
            '</div>'+
            '<div class="summary-block"><h3>RINGKASAN DATA</h3>'+
              kv('Total Panen (Ekor)',prodFmt(harvestBirds,0))+
              kv('Total Berat (Kg)',n2(harvestKg))+
              kv('Rata-rata BB (Kg/Ekor)',prodFmt(avgBw,2))+
              kv('Pakan Bersih (Zak)',n2(totalFeedBags))+
              kv('Pakan Bersih (Kg)',n2(feedKg))+
              kv('Harga DOC (Rp/Ekor)',money(docPrice))+
              kv('Tarif Bonus IP (Rp/Kg)',money(src.bonus_ip_rate))+
              kv('Total Nilai Panen (Rp)',money(src.harvest_value))+
              kv('DIFF FCR',prodFmt(fcrDiff,3))+
              kv('Tarif Bonus FC (Rp/Kg)',money(src.bonus_fc_rate))+
            '</div>'+
            '<div class="summary-block rhpp-value"><h3>NILAI RHPP</h3>'+
              kv('Jml. Sapronak',money(prodNum(src.sapronak_cost)+prodNum(src.main_return_cost)))+
              kv('Jml. Retur',money(src.main_return_cost))+
              kv('Total Sapronak',money(src.sapronak_cost))+
              kv('Total Hasil Produksi',money(src.harvest_value))+
              kv('Laba',money(src.base_profit))+
              kv('Bonus IP',money(src.bonus_ip))+
              kv('Bonus FC',money(src.bonus_fc))+
              kv('Bonus Mortalitas',money(src.bonus_depletion||src.bonus_mortality))+
              kv('Laba Peternak',money(src.system_amount||src.farmer_profit))+
              kv('Laba Per Ekor',money(src.profit_per_chick_in))+
            '</div>'+
          '</div>'+
          '<footer class="footer"><div><strong>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</strong><br>'+esc(companyName)+'</div><div style="text-align:right"><strong>Halaman 2 dari 2</strong><br>Dicetak: '+esc(printStamp)+'</div></footer>'+
        '</section>'+
        '</body></html>';
    };;
        const openPrint=()=>{
      const w=window.open('','_blank');if(!w)return msg('Popup cetak diblokir browser.');
      w.document.write(docHtml());w.document.close();
      setTimeout(()=>{w.focus();w.print();},450);
    };
    const pBtn=document.getElementById('pplRhppPrint');
    const pdfBtn=document.getElementById('pplRhppPdf');
    const xBtn=document.getElementById('pplRhppExcel');
    if(pBtn)pBtn.onclick=openPrint;
    if(pdfBtn)pdfBtn.onclick=openPrint;
    if(xBtn)xBtn.onclick=()=>{
      const clone=exportArea?.cloneNode(true);if(!clone)return;
      clone.querySelectorAll('button,.report-actions').forEach(x=>x.remove());
      const blob=new Blob(['\ufeff<html><head><meta charset="utf-8"></head><body><h2>'+esc(company.company_name||'BMS Mobile')+'</h2><h3>RHPP Sistem</h3>'+clone.innerHTML+'</body></html>'],{type:'application/vnd.ms-excel;charset=utf-8'});
      const url=URL.createObjectURL(blob),link=document.createElement('a');
      link.href=url;link.download=fileBase+'.xls';document.body.appendChild(link);link.click();link.remove();
      setTimeout(()=>URL.revokeObjectURL(url),1000);
    };
  }
}
async function financeBopPage(){
  const [br,ar,cr,bopr]=await Promise.all([
    db.from('barns').select('id,code,name').order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active,created_at').order('start_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('bop').select('id,contract_assignment_id,barn_id,incurred_on,category,amount,reference,notes').order('incurred_on',{ascending:false}).order('id',{ascending:false})
  ]);
  const barns=br.data||[],assignments=ar.data||[],contractsRows=cr.data||[],rows=bopr.data||[];
  const err=[br,ar,cr,bopr].find(x=>x.error)?.error;
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  window.__financeBopState=window.__financeBopState||{barn:'',assignment:'',filterBarn:'',filterAssignment:'',from:'',to:'',shown:false};
  const st=window.__financeBopState;
  const selectedBarn=st.barn||'';
  const cycleOptions=selectedBarn?assignments.filter(a=>a.barn_id===selectedBarn):[];

  const filterRows=st.shown?rows.filter(x=>
    (!st.filterBarn||x.barn_id===st.filterBarn)&&
    (!st.filterAssignment||x.contract_assignment_id===st.filterAssignment)&&
    (!st.from||String(x.incurred_on||'')>=st.from)&&
    (!st.to||String(x.incurred_on||'')<=st.to)
  ):[];

  const assignmentText=id=>{
    const a=assignments.find(x=>x.id===id);
    if(!a)return '-';
    const b=barns.find(x=>x.id===a.barn_id);
    const k=contractsRows.find(x=>x.id===a.master_contract_id);
    return (b?shortBarnLabel(b):'-')+' · '+assignmentCycleLabel(assignments,a)+' · '+(k?.number||'-')+' · '+(a.active?'PROSES':'CLOSED');
  };

  let html='<section class="panel"><h3>Tambah BOP Kandang</h3>'+
    '<p class="muted">BOP dapat dicatat ke siklus PROSES maupun CLOSED. BOP tetap terpisah dan tidak mengubah RHPP Sistem Final.</p>'+
    '<form id="bopKandangForm" class="form-vertical">'+
      '<label>Kandang<select id="bopBarn" name="barn_id" required><option value="">Pilih Kandang</option>'+
        barns.map(b=>'<option value="'+esc(b.id)+'" '+(selectedBarn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+
      '</select></label>'+
      '<label>Siklus / Periode<select id="bopAssignment" name="contract_assignment_id" required '+(!selectedBarn?'disabled':'')+'><option value="">Pilih Siklus / Periode</option>'+
        cycleOptions.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('')+
      '</select></label>'+
      '<label>Tanggal<input name="incurred_on" type="date" value="'+today+'" required></label>'+
      '<label>Kategori<select name="category" required>'+
        '<option value="">Pilih Kategori</option>'+
        '<option value="OVK">OVK</option>'+
        '<option value="TENAGA_KERJA">Tenaga Kerja</option>'+
        '<option value="TRANSPORTASI">Transportasi</option>'+
        '<option value="LISTRIK">Listrik</option>'+
        '<option value="PERBAIKAN">Perbaikan</option>'+
        '<option value="EKSPEDISI">Ekspedisi</option>'+
        '<option value="LAINNYA">Lainnya</option>'+
      '</select></label>'+
      '<label>Nominal (Rp)<input name="amount" type="text" inputmode="decimal" data-number="1" required></label>'+
      ''+
      '<label>Catatan<textarea name="notes" placeholder="Opsional"></textarea></label>'+
      '<button type="submit">Simpan</button>'+
    '</form></section>'+
    '<section class="panel" id="bopKandangPrintArea"><div class="rhpp-section-head"><div><h3>Data BOP Kandang</h3></div><div class="report-actions"><button type="button" id="bopKandangPrint">Cetak / PDF</button></div></div>'+
      '<form id="bopKandangFilter" class="form-vertical">'+
        '<label>Kandang<select name="barn"><option value="">Semua Kandang</option>'+barns.map(b=>'<option value="'+esc(b.id)+'" '+(st.filterBarn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
        '<label>Siklus<select name="assignment" '+(!st.filterBarn?'disabled':'')+'><option value="">Semua Siklus</option>'+
          assignments.filter(a=>a.barn_id===st.filterBarn).map(a=>'<option value="'+esc(a.id)+'" '+(st.filterAssignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('')+
        '</select></label>'+
        '<label>Tanggal Dari<input name="from" type="date" value="'+esc(st.from||'')+'"></label>'+
        '<label>Tanggal Sampai<input name="to" type="date" value="'+esc(st.to||'')+'"></label>'+
        '<div class="report-actions"><button type="submit">Tampilkan</button><button type="button" id="bopKandangReset">Reset</button></div>'+
      '</form>'+
      (st.shown?
        '<div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>Kandang / Siklus</th><th>Status</th><th>Kategori</th><th>Nominal</th><th>Referensi</th><th>Catatan</th></tr></thead><tbody>'+
          filterRows.map(x=>{const a=assignments.find(v=>v.id===x.contract_assignment_id);return '<tr><td>'+prodDateId(x.incurred_on)+'</td><td>'+esc(assignmentText(x.contract_assignment_id))+'</td><td>'+(a?.active?'PROSES':'CLOSED')+'</td><td>'+esc(String(x.category||'').replaceAll('_',' '))+'</td><td>Rp '+prodFmt(x.amount,0)+'</td><td>'+esc(x.reference||'-')+'</td><td>'+esc(x.notes||'-')+'</td></tr>';}).join('')+
        '</tbody></table></div>'+(filterRows.length?'':'<p class="muted">Tidak ada BOP sesuai filter.</p>')
        :'<p class="muted">Pilih filter lalu tekan Tampilkan.</p>')+
    '</section>';

  layout(html);
  bindNumberInputs();
  if(err)msg(err.message);

  const barnSel=document.getElementById('bopBarn');
  if(barnSel)barnSel.onchange=async()=>{
    st.barn=barnSel.value||'';
    st.assignment='';
    await financeBopPage();
  };

  const form=document.getElementById('bopKandangForm');
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form);
    const assignmentId=String(fd.get('contract_assignment_id')||'');
    const a=assignments.find(x=>x.id===assignmentId);
    if(!a)return msg('Pilih siklus / periode.');
    const amount=normalizeInputID(fd.get('amount'));
    if(amount===null||amount<0)return msg('Nominal BOP tidak valid.');
    const payload={
      contract_assignment_id:assignmentId,
      barn_id:a.barn_id,
      incurred_on:fd.get('incurred_on'),
      category:fd.get('category'),
      amount,
      reference:null,
      notes:fd.get('notes')||null
    };
    const {error}=await db.from('bop').insert(payload);
    if(error)return msg(error.message);
    const keepBarn=st.barn,keepAssignment=st.assignment;
    await financeBopPage();
    window.__financeBopState.barn=keepBarn;
    window.__financeBopState.assignment=keepAssignment;
    msg('BOP Kandang berhasil disimpan ke '+assignmentText(assignmentId)+'.',true);
  };

  const filter=document.getElementById('bopKandangFilter');
  if(filter){
    filter.elements.barn.onchange=async()=>{
      st.filterBarn=filter.elements.barn.value||'';
      st.filterAssignment='';
      st.shown=false;
      await financeBopPage();
    };
    filter.onsubmit=async ev=>{
      ev.preventDefault();
      const fd=new FormData(filter);
      st.filterBarn=String(fd.get('barn')||'');
      st.filterAssignment=st.filterBarn?String(fd.get('assignment')||''):'';
      st.from=String(fd.get('from')||'');
      st.to=String(fd.get('to')||'');
      if(st.from&&st.to&&st.from>st.to){const t=st.from;st.from=st.to;st.to=t;}
      st.shown=true;
      await financeBopPage();
    };
  }
  const bopPrint=document.getElementById('bopKandangPrint');if(bopPrint)bopPrint.onclick=()=>printFinanceDocument('bopKandangPrintArea','Laporan BOP Kandang');
  const reset=document.getElementById('bopKandangReset');
  if(reset)reset.onclick=async()=>{
    st.filterBarn='';st.filterAssignment='';st.from='';st.to='';st.shown=false;
    await financeBopPage();
  };
}

async function financeBopGeneralPage(){
  const {data,error}=await db.from('bop_outside').select('*').order('incurred_on',{ascending:false}).order('created_at',{ascending:false});
  const rows=data||[];
  const txn=txnListState(rows,'bop_outside','incurred_on',5);
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  let html='<section class="panel"><h3>Tambah BOP Umum</h3>'+
    '<form id="bopOutsideForm" class="form-vertical">'+
      '<label>Tanggal<input name="incurred_on" type="date" value="'+today+'" required></label>'+
      '<label>Kategori<select name="category" required>'+
        '<option value="">Pilih Kategori</option>'+
        '<option value="TENAGA_KERJA">Tenaga Kerja</option>'+
        '<option value="TRANSPORTASI">Transportasi</option>'+
        '<option value="LISTRIK">Listrik</option>'+
        '<option value="PERBAIKAN">Perbaikan</option>'+
        '<option value="ADMINISTRASI">Administrasi</option>'+
        '<option value="LAINNYA">Lainnya</option>'+
      '</select></label>'+
      '<label>Nominal (Rp)<input name="amount" type="text" inputmode="decimal" data-number="1" required></label>'+
      ''+
      '<label>Catatan<textarea name="notes" placeholder="Opsional"></textarea></label>'+
      '<button type="submit">Simpan</button>'+
    '</form></section>'+
    '<section class="panel" id="bopUmumPrintArea"><div class="rhpp-section-head"><div><h3>Data BOP Umum</h3></div><div class="report-actions"><button type="button" id="bopUmumPrint">Cetak / PDF</button></div></div>'+txn.controls+
      '<div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>Kategori</th><th>Nominal</th><th>Referensi</th><th>Catatan</th></tr></thead><tbody>'+
      txn.rows.map(x=>'<tr><td>'+prodDateId(x.incurred_on)+'</td><td>'+esc(String(x.category||'').replaceAll('_',' '))+'</td><td>Rp '+prodFmt(x.amount,0)+'</td><td>'+esc(x.reference||'-')+'</td><td>'+esc(x.notes||'-')+'</td></tr>').join('')+
      '</tbody></table></div>'+
      (!txn.total?'<p>Belum ada data.</p>':'')+txn.pager+
    '</section>';

  layout(html);
  bindNumberInputs();
  bindTxnList(txn,()=>financeBopGeneralPage());const bopUmumPrint=document.getElementById('bopUmumPrint');if(bopUmumPrint)bopUmumPrint.onclick=()=>printFinanceDocument('bopUmumPrintArea','Laporan BOP Umum');
  if(error)msg(error.message);

  const form=document.getElementById('bopOutsideForm');
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form);
    const amount=normalizeInputID(fd.get('amount'));
    if(amount===null||amount<0)return msg('Nominal BOP Umum tidak valid.');
    const payload={
      incurred_on:fd.get('incurred_on'),
      category:fd.get('category'),
      amount,
      reference:null,
      notes:fd.get('notes')||null
    };
    const {error}=await db.from('bop_outside').insert(payload);
    if(error)return msg(error.message);
    await financeBopGeneralPage();
    msg('BOP Umum berhasil disimpan.',true);
  };
}



async function financeExpeditionBusinessPage(){
  const [tr,ir,iir,pr,sr,cpr]=await Promise.all([
    db.from('finance_expedition_trips').select('*').order('trip_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('finance_expedition_invoices').select('*').order('invoice_date',{ascending:false}).order('created_at',{ascending:false}),
    db.from('finance_expedition_invoice_items').select('invoice_id,trip_id'),
    db.from('finance_expedition_payments').select('*').order('paid_on',{ascending:false}),
    db.rpc('finance_expedition_summary_v1'),
    db.from('company_profile').select('*').eq('id',true).maybeSingle()
  ]);
  const trips=tr.data||[],invoices=ir.data||[],links=iir.data||[],payments=pr.data||[],summaries=sr.data||[],company=cpr.data||{};
  const err=[tr,ir,iir,pr,sr,cpr].find(x=>x.error)?.error;
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());
  const used=new Set(links.map(x=>x.trip_id));
  const unbilled=trips.filter(x=>!used.has(x.id));
  const tripTotal=t=>prodNum(t.trip_price)+prodNum(t.additional)-prodNum(t.deduction);
  const invoiceTrips=id=>links.filter(x=>x.invoice_id===id).map(x=>trips.find(t=>t.id===x.trip_id)).filter(Boolean);
  const sumFor=id=>summaries.find(x=>x.invoice_id===id);
  const invoiceLabel=id=>{const i=invoices.find(x=>x.id===id),s=sumFor(id);return i?i.invoice_number+' · '+i.customer_name+' · Sisa Rp '+prodFmt(s?.receivable||0,0):'-';};

  let html='<section class="panel"><h3>Tambah Trip Expedisi</h3>'+
    '<p class="muted">Unit usaha Expedisi berdiri sendiri dan tidak terhubung ke kandang/RHPP internal.</p>'+
    '<form id="fxTripForm" class="form-vertical">'+
      '<label>Tanggal<input name="trip_date" type="date" value="'+today+'" required></label>'+
      '<label>MTS/SJ<input name="mts_sj"></label>'+
      '<label>RR<input name="rr"></label>'+
      '<label>Sopir<input name="driver"></label>'+
      '<label>Truk<input name="vehicle" placeholder="Contoh: D 9399 UA"></label>'+
      '<label>Zona / Rute<input name="zone" placeholder="Contoh: Cirebon-Majalengka"></label>'+
      '<label>Tujuan<input name="destination" required></label>'+
      '<label>Jenis Muatan / Qty<input name="cargo" placeholder="Contoh: BFP Premium 160 zak"></label>'+
      '<label>Total Qty<input name="total_qty" type="text" inputmode="decimal" data-number="1"></label>'+
      '<label>Harga Trip<input name="trip_price" type="text" inputmode="decimal" data-number="1" required></label>'+
      '<label>Tambahan<input name="additional" type="text" inputmode="decimal" data-number="1" value="0"></label>'+
      '<label>Potongan<input name="deduction" type="text" inputmode="decimal" data-number="1" value="0"></label>'+
      ''+
      '<label>Catatan<textarea name="notes"></textarea></label>'+
      '<button type="submit">Simpan Trip</button>'+
    '</form></section>'+
    '<section class="panel"><h3>Trip Belum Ditagihkan</h3><div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>MTS/SJ</th><th>RR</th><th>Sopir</th><th>Truk</th><th>Zona</th><th>Tujuan</th><th>Muatan</th><th>Qty</th><th>Total Trip</th></tr></thead><tbody>'+
      unbilled.map(t=>'<tr><td>'+prodDateId(t.trip_date)+'</td><td>'+esc(t.mts_sj||'-')+'</td><td>'+esc(t.rr||'-')+'</td><td>'+esc(t.driver||'-')+'</td><td>'+esc(t.vehicle||'-')+'</td><td>'+esc(t.zone||'-')+'</td><td>'+esc(t.destination||'-')+'</td><td>'+esc(t.cargo||'-')+'</td><td>'+prodFmt(t.total_qty||0,0)+'</td><td>Rp '+prodFmt(tripTotal(t),0)+'</td></tr>').join('')+
    '</tbody></table></div>'+(unbilled.length?'':'<p class="muted">Tidak ada trip yang belum ditagihkan.</p>')+'</section>'+
    '<section class="panel"><h3>Buat Invoice Expedisi</h3>'+
      '<p class="muted">Pilih satu atau beberapa trip. Total invoice dihitung otomatis dari Harga Trip + Tambahan − Potongan.</p>'+
      '<form id="fxInvoiceForm" class="form-vertical">'+
        '<label>No Invoice<input name="invoice_number" placeholder="Contoh: 001/BMS-BSI/FMC/2026" required></label>'+
        '<label>Tanggal Invoice<input name="invoice_date" type="date" value="'+today+'" required></label>'+
        '<label>Jatuh Tempo<input name="due_date" type="date"></label>'+
        '<label>Tagihan Kepada<input name="customer_name" required></label>'+
        '<label>Alamat Pelanggan<textarea name="customer_address"></textarea></label>'+
        '<fieldset><legend>Pilih Trip</legend>'+
          unbilled.map(t=>'<label style="display:flex;gap:8px;align-items:center"><input type="checkbox" name="trip_ids" value="'+esc(t.id)+'"><span>'+esc(prodDateId(t.trip_date)+' · '+(t.mts_sj||'-')+' · '+t.destination+' · Rp '+prodFmt(tripTotal(t),0))+'</span></label>').join('')+
          (unbilled.length?'':'<p class="muted">Belum ada trip tersedia.</p>')+
        '</fieldset>'+
        '<label>Catatan<textarea name="notes"></textarea></label>'+
        '<button type="submit" '+(!unbilled.length?'disabled':'')+'>Buat Invoice</button>'+
      '</form></section>'+
    '<section class="panel"><h3>Invoice Expedisi</h3><div class="tablewrap"><table><thead><tr><th>No Invoice</th><th>Tanggal</th><th>Pelanggan</th><th>Total</th><th>Dibayar</th><th>Piutang</th><th>Status</th><th>Aksi</th></tr></thead><tbody>'+
      summaries.map(s=>'<tr><td>'+esc(s.invoice_number)+'</td><td>'+prodDateId(s.invoice_date)+'</td><td>'+esc(s.customer_name)+'</td><td>Rp '+prodFmt(s.invoice_total,0)+'</td><td>Rp '+prodFmt(s.paid_total,0)+'</td><td>Rp '+prodFmt(s.receivable,0)+'</td><td>'+esc(s.status)+'</td><td><button type="button" data-fx-print="'+esc(s.invoice_id)+'">Cetak</button></td></tr>').join('')+
    '</tbody></table></div>'+(summaries.length?'':'<p class="muted">Belum ada invoice Expedisi.</p>')+'</section>'+
    '<section class="panel"><h3>Pembayaran Invoice Expedisi</h3><form id="fxPaymentForm" class="form-vertical">'+
      '<label>Invoice<select name="invoice_id" required><option value="">Pilih Invoice</option>'+summaries.filter(s=>prodNum(s.receivable)>0&&s.status!=='VOID').map(s=>'<option value="'+esc(s.invoice_id)+'">'+esc(invoiceLabel(s.invoice_id))+'</option>').join('')+'</select></label>'+
      '<label>Tanggal Bayar<input name="paid_on" type="date" value="'+today+'" required></label>'+
      '<label>Nominal<input name="amount" id="fxBopAmount" type="text" inputmode="decimal" data-number="1" required></label>'+
      '<label>Metode<input name="method" placeholder="Transfer / Tunai"></label>'+
      ''+
      '<label>Catatan<textarea name="notes"></textarea></label>'+
      '<button type="submit">Simpan Pembayaran</button>'+
    '</form></section>';

  layout(html);bindNumberInputs();if(err)msg(err.message);

  const tf=document.getElementById('fxTripForm');
  if(tf)tf.onsubmit=async ev=>{
    ev.preventDefault();const fd=new FormData(tf);
    const tripPrice=normalizeInputID(fd.get('trip_price')),additional=normalizeInputID(fd.get('additional'))||0,deduction=normalizeInputID(fd.get('deduction'))||0,totalQty=normalizeInputID(fd.get('total_qty'));
    if(tripPrice===null||tripPrice<0||additional<0||deduction<0)return msg('Nilai trip tidak valid.');
    const {error}=await db.from('finance_expedition_trips').insert({
      trip_date:fd.get('trip_date'),mts_sj:fd.get('mts_sj')||null,rr:fd.get('rr')||null,driver:fd.get('driver')||null,vehicle:fd.get('vehicle')||null,
      zone:fd.get('zone')||null,destination:fd.get('destination'),cargo:fd.get('cargo')||null,total_qty:totalQty,trip_price:tripPrice,additional,deduction,
      reference:null,notes:fd.get('notes')||null
    });
    if(error)return msg(error.message);await financeExpeditionBusinessPage();msg('Trip Expedisi berhasil disimpan.',true);
  };

  const inf=document.getElementById('fxInvoiceForm');
  if(inf)inf.onsubmit=async ev=>{
    ev.preventDefault();const fd=new FormData(inf),ids=fd.getAll('trip_ids').map(String);
    if(!ids.length)return msg('Pilih minimal satu trip.');
    const {error}=await db.rpc('finance_create_expedition_invoice_atomic',{
      p_invoice_number:String(fd.get('invoice_number')||''),p_invoice_date:String(fd.get('invoice_date')||''),p_due_date:String(fd.get('due_date')||'')||null,
      p_customer_name:String(fd.get('customer_name')||''),p_customer_address:String(fd.get('customer_address')||'')||null,p_trip_ids:ids,p_notes:String(fd.get('notes')||'')||null
    });
    if(error)return msg(error.message);await financeExpeditionBusinessPage();msg('Invoice Expedisi berhasil dibuat.',true);
  };

  const pf=document.getElementById('fxPaymentForm');
  if(pf)pf.onsubmit=async ev=>{
    ev.preventDefault();const fd=new FormData(pf),id=String(fd.get('invoice_id')||''),amount=normalizeInputID(fd.get('amount')),s=summaries.find(x=>x.invoice_id===id);
    if(!s)return msg('Pilih invoice.');if(amount===null||amount<=0||amount>prodNum(s.receivable))return msg('Nominal pembayaran tidak valid atau melebihi piutang.');
    const {error}=await db.from('finance_expedition_payments').insert({invoice_id:id,paid_on:fd.get('paid_on'),amount,method:fd.get('method')||null,reference:null,notes:fd.get('notes')||null});
    if(error)return msg(error.message);
    if(Math.abs(amount-prodNum(s.receivable))<0.001)await db.from('finance_expedition_invoices').update({status:'PAID'}).eq('id',id);
    await financeExpeditionBusinessPage();msg('Pembayaran invoice Expedisi berhasil disimpan.',true);
  };

  document.querySelectorAll('[data-fx-print]').forEach(btn=>btn.onclick=()=>{
    const id=btn.dataset.fxPrint,i=invoices.find(x=>x.id===id),its=invoiceTrips(id),s=sumFor(id);if(!i)return;
    const rows=its.map((t,idx)=>'<tr><td>'+(idx+1)+'</td><td>'+prodDateId(t.trip_date)+'</td><td>'+esc(t.mts_sj||'-')+'</td><td>'+esc(t.rr||'-')+'</td><td>'+esc(t.driver||'-')+'</td><td>'+esc(t.vehicle||'-')+'</td><td>'+esc(t.zone||'-')+'</td><td>'+esc(t.destination||'-')+'</td><td>'+esc(t.cargo||'-')+'</td><td>'+prodFmt(t.total_qty||0,0)+'</td><td>Rp '+prodFmt(t.trip_price,0)+'</td><td>Rp '+prodFmt(t.additional,0)+'</td><td>Rp '+prodFmt(t.deduction,0)+'</td><td>Rp '+prodFmt(tripTotal(t),0)+'</td></tr>').join('');
    const w=window.open('','_blank');if(!w)return msg('Popup cetak diblokir browser.');
    w.document.write('<html><head><meta charset="utf-8"><title>'+esc(i.invoice_number)+'</title><style>body{font-family:Arial,sans-serif;padding:24px;font-size:12px}h1{text-align:right}table{width:100%;border-collapse:collapse;margin-top:18px}th,td{border:1px solid #ccc;padding:5px}th{background:#eee}.head{display:flex;justify-content:space-between}.total{text-align:right;font-size:18px;font-weight:bold;margin-top:14px}</style></head><body>'+
      '<div class="head"><div><h2>'+esc(company.company_name||company.legal_name||'Bagjasindo Mandiri Sindangkasih')+'</h2><div>'+esc(company.address||'')+'</div></div><div><h1>INVOICE</h1><div>No: '+esc(i.invoice_number)+'</div><div>Tanggal: '+prodDateId(i.invoice_date)+'</div><div>Jatuh Tempo: '+(i.due_date?prodDateId(i.due_date):'-')+'</div></div></div>'+
      '<hr><h3>Tagihan Kepada:</h3><strong>'+esc(i.customer_name)+'</strong><div>'+esc(i.customer_address||'')+'</div>'+
      '<table><thead><tr><th>No</th><th>Tanggal</th><th>MTS/SJ</th><th>RR</th><th>Sopir</th><th>Truk</th><th>Zona</th><th>Tujuan</th><th>Jenis Pakan / Qty</th><th>Total Qty</th><th>Harga Trip</th><th>Tambahan</th><th>Potongan</th><th>Total</th></tr></thead><tbody>'+rows+'</tbody></table>'+
      '<div class="total">TOTAL INVOICE &nbsp; Rp '+prodFmt(s?.invoice_total||0,0)+'</div>'+
      '<h3>PEMBAYARAN</h3><div>Bank: '+esc(company.bank_name||'-')+'</div><div>No. Rekening: '+esc(company.bank_account_number||'-')+'</div><div>a.n. '+esc(company.bank_account_name||company.company_name||company.legal_name||'-')+'</div>'+
      '</body></html>');
    w.document.close();setTimeout(()=>{w.focus();w.print();},400);
  });
}

async function financeExpeditionBopPage(){
  const [br,tr]=await Promise.all([
    db.from('finance_expedition_bop').select('*').order('incurred_on',{ascending:false}).order('created_at',{ascending:false}),
    db.from('finance_expedition_trips').select('id,trip_date,mts_sj,driver,vehicle,zone,destination').order('trip_date',{ascending:false})
  ]);
  const rows=br.data||[],trips=tr.data||[],err=(br.error||tr.error);
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());
  let html='<section class="panel"><h3>Tambah BOP Expedisi</h3><p class="muted">Biaya usaha Expedisi terpisah dari BOP Kandang dan BOP Umum.</p>'+
    '<form id="fxBopForm" class="form-vertical">'+
      '<label>Tanggal<input name="incurred_on" type="date" value="'+today+'" required></label>'+
      '<label>Kategori<select name="category" required><option value="">Pilih Kategori</option><option value="BBM">BBM</option><option value="TOL">Tol</option><option value="PARKIR">Parkir</option><option value="UANG_JALAN">Uang Jalan</option><option value="MAKAN_SOPIR">Makan Sopir</option><option value="SERVIS">Servis</option><option value="BAN">Ban</option><option value="PAJAK_KENDARAAN">Pajak Kendaraan</option><option value="BONGKAR_MUAT">Bongkar / Muat</option><option value="LAINNYA">Lainnya</option></select></label>'+
      '<label>Trip Terkait (opsional)<select name="trip_id"><option value="">Tidak terkait trip tertentu</option>'+trips.map(t=>'<option value="'+esc(t.id)+'">'+esc(prodDateId(t.trip_date)+' · '+(t.mts_sj||'-')+' · '+t.destination)+'</option>').join('')+'</select></label>'+
      '<label>Sopir<input name="driver"></label><label>Truk<input name="vehicle"></label><label>Rute<input name="route"></label>'+
      '<label>Qty<input name="qty" type="text" inputmode="decimal" data-number="1"></label>'+
      '<label>Harga Satuan<input name="unit_price" type="text" inputmode="decimal" data-number="1"></label>'+
      '<label>Nominal<input name="amount" type="text" inputmode="decimal" data-number="1" required></label>'+
      '<label>Catatan<textarea name="notes"></textarea></label>'+
      '<button type="submit">Simpan BOP Expedisi</button></form></section>'+
    '<section class="panel" id="fxBopPrintArea"><div class="rhpp-section-head"><div><h3>Data BOP Expedisi</h3></div><div class="report-actions"><button type="button" id="fxBopPrint">Cetak / PDF</button></div></div><div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>Kategori</th><th>Sopir</th><th>Truk</th><th>Rute</th><th>Nominal</th><th>Referensi</th></tr></thead><tbody>'+
      rows.map(x=>'<tr><td>'+prodDateId(x.incurred_on)+'</td><td>'+esc(String(x.category||'').replaceAll('_',' '))+'</td><td>'+esc(x.driver||'-')+'</td><td>'+esc(x.vehicle||'-')+'</td><td>'+esc(x.route||'-')+'</td><td>Rp '+prodFmt(x.amount,0)+'</td><td>'+esc(x.reference||'-')+'</td></tr>').join('')+
    '</tbody></table></div>'+(rows.length?'':'<p class="muted">Belum ada BOP Expedisi.</p>')+'</section>';
  layout(html);bindNumberInputs();if(err)msg(err.message);
  const fxBopPrint=document.getElementById('fxBopPrint');if(fxBopPrint)fxBopPrint.onclick=()=>printFinanceDocument('fxBopPrintArea','Laporan BOP Expedisi');
  const form=document.getElementById('fxBopForm');
  if(form){
    const qtyInput=form.elements.qty,unitInput=form.elements.unit_price,amountInput=form.elements.amount;
    const syncFxBopAmount=()=>{
      const q=normalizeInputID(qtyInput.value),u=normalizeInputID(unitInput.value);
      if(q!==null&&u!==null&&q>0&&u>=0){amountInput.value=fmtNumber(q*u);amountInput.dataset.autoAmount='1';amountInput.readOnly=true;amountInput.title='Otomatis: Qty × Harga Satuan';}
      else{if(amountInput.dataset.autoAmount==='1')amountInput.value='';delete amountInput.dataset.autoAmount;amountInput.readOnly=false;amountInput.title='';}
    };
    qtyInput.addEventListener('input',syncFxBopAmount);unitInput.addEventListener('input',syncFxBopAmount);syncFxBopAmount();
  }
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();const fd=new FormData(form),amount=normalizeInputID(fd.get('amount')),qty=normalizeInputID(fd.get('qty')),unitPrice=normalizeInputID(fd.get('unit_price'));
    if(amount===null||amount<0)return msg('Nominal BOP Expedisi tidak valid.');
    const {error}=await db.from('finance_expedition_bop').insert({
      incurred_on:fd.get('incurred_on'),category:fd.get('category'),trip_id:fd.get('trip_id')||null,driver:fd.get('driver')||null,vehicle:fd.get('vehicle')||null,route:fd.get('route')||null,
      qty,unit_price:unitPrice,amount,reference:null,notes:fd.get('notes')||null
    });
    if(error)return msg(error.message);await financeExpeditionBopPage();msg('BOP Expedisi berhasil disimpan.',true);
  };
}

async function financeAdvancePage(){
  const [br,ar,cr,lr,er,vr,pr]=await Promise.all([
    db.from('barns').select('id,code,name').order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active,created_at').order('start_date',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('logistics_contract_assignment_abks').select('contract_assignment_id,abk_id'),
    db.from('employees').select('id,code,name,kind,active').eq('active',true).order('code',{ascending:true}),
    db.from('advances').select('id,employee_id,contract_assignment_id,barn_id,advanced_on,amount,description,reference,created_at').order('advanced_on',{ascending:false}),
    db.from('advance_payments').select('advance_id,amount')
  ]);
  const barns=br.data||[],assignments=ar.data||[],contractsRows=cr.data||[],links=lr.data||[],employees=er.data||[],rows=vr.data||[],payments=pr.data||[];
  const err=[br,ar,cr,lr,er,vr,pr].find(x=>x.error)?.error;
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  window.__financeAdvanceState=window.__financeAdvanceState||{employee:'',barn:'',assignment:''};
  const st=window.__financeAdvanceState;
  const selectedEmployee=employees.find(x=>x.id===st.employee);
  const isAbk=selectedEmployee?.kind==='ABK';
  const abkAssignmentIds=new Set(links.filter(x=>x.abk_id===st.employee).map(x=>x.contract_assignment_id));
  const abkBarnIds=new Set(assignments.filter(a=>abkAssignmentIds.has(a.id)).map(a=>a.barn_id));
  const selectableBarns=isAbk?barns.filter(b=>abkBarnIds.has(b.id)):[];
  const cycles=isAbk&&st.barn?assignments.filter(a=>a.barn_id===st.barn&&abkAssignmentIds.has(a.id)):[];
  const paid=id=>payments.filter(x=>x.advance_id===id).reduce((n,x)=>n+prodNum(x.amount),0);
  const emp=id=>{const x=employees.find(e=>e.id===id);return x?x.code+' · '+x.name:'-'};
  const identity=id=>{const a=assignments.find(x=>x.id===id);return a?assignmentIdentity(assignments,barns,contractsRows,a):'KARYAWAN UMUM';};

  let html='<section class="panel"><h3>Kasbon Karyawan</h3>'+
    '<p class="muted">ABK wajib terkait Kandang + Siklus. Karyawan umum tidak terikat kandang/siklus. Semua kasbon tetap tercatat sebagai kas keluar dan saldo piutang karyawan.</p>'+
    '<form id="financeAdvanceForm" class="form-vertical">'+
      '<label>Karyawan<select id="advanceEmployee" name="employee_id" required><option value="">Pilih Karyawan</option>'+
        employees.map(x=>'<option value="'+esc(x.id)+'" '+(st.employee===x.id?'selected':'')+'>'+esc(x.code+' · '+x.name+' · '+(x.kind==='ABK'?'ABK':'KARYAWAN'))+'</option>').join('')+
      '</select></label>'+
      (isAbk
        ?'<label>Kandang<select id="advanceBarn" name="barn_id" required><option value="">Pilih Kandang</option>'+selectableBarns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
         '<label>Siklus<select id="advanceCycle" name="contract_assignment_id" required '+(!st.barn?'disabled':'')+'><option value="">Pilih Siklus</option>'+cycles.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('')+'</select></label>'
        :selectedEmployee?'<p class="muted"><strong>Karyawan Umum:</strong> Kasbon tidak dibebankan ke kandang/siklus.</p>':'')+
      '<label>Tanggal Kasbon<input name="advanced_on" type="date" value="'+today+'" required></label>'+
      '<label>Nominal<input name="amount" type="text" inputmode="decimal" data-number="1" required></label>'+
      '<label>Keterangan<input name="description"></label>'+
      ''+
      '<button type="submit">Simpan Kasbon</button>'+
    '</form></section>'+
    '<section class="panel" id="advancePrintArea"><div class="rhpp-section-head"><div><h3>Saldo Kasbon Karyawan</h3></div><div class="report-actions"><button type="button" id="advancePrint">Cetak / PDF</button></div></div><div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>Karyawan</th><th>Jenis</th><th>Kandang / Siklus</th><th>Kasbon</th><th>Terpotong/Dibayar</th><th>Sisa</th></tr></thead><tbody>'+
    rows.map(x=>{const e=employees.find(v=>v.id===x.employee_id),p=paid(x.id),bal=prodNum(x.amount)-p;return '<tr><td>'+prodDateId(x.advanced_on)+'</td><td>'+esc(emp(x.employee_id))+'</td><td>'+esc(e?.kind==='ABK'?'ABK':'KARYAWAN')+'</td><td>'+esc(identity(x.contract_assignment_id))+'</td><td>Rp '+prodFmt(x.amount,0)+'</td><td>Rp '+prodFmt(p,0)+'</td><td><strong>Rp '+prodFmt(bal,0)+'</strong></td></tr>';}).join('')+
    '</tbody></table></div>'+(rows.length?'':'<p class="muted">Belum ada kasbon.</p>')+'</section>';

  layout(html);bindNumberInputs();if(err)msg(err.message);

  const advancePrint=document.getElementById('advancePrint');if(advancePrint)advancePrint.onclick=()=>printFinanceDocument('advancePrintArea','Laporan Saldo Kasbon Karyawan');
  const employeeSel=document.getElementById('advanceEmployee');
  const barnSel=document.getElementById('advanceBarn');
  const cycleSel=document.getElementById('advanceCycle');
  if(employeeSel)employeeSel.onchange=async()=>{
    st.employee=employeeSel.value||'';st.barn='';st.assignment='';
    await financeAdvancePage();
  };
  if(barnSel)barnSel.onchange=async()=>{st.barn=barnSel.value||'';st.assignment='';await financeAdvancePage();};
  if(cycleSel)cycleSel.onchange=async()=>{st.assignment=cycleSel.value||'';await financeAdvancePage();};

  const form=document.getElementById('financeAdvanceForm');
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form),amount=normalizeInputID(fd.get('amount'));
    const employeeId=String(fd.get('employee_id')||'');
    const employee=employees.find(x=>x.id===employeeId);
    if(!employee)return msg('Pilih karyawan.');
    if(amount===null||amount<=0)return msg('Nominal kasbon tidak valid.');
    if(employee.kind==='ABK'&&!st.assignment)return msg('Kasbon ABK wajib memilih Kandang dan Siklus.');
    const {error}=await db.rpc('finance_save_employee_advance_atomic',{
      p_employee_id:employeeId,
      p_advanced_on:String(fd.get('advanced_on')||''),
      p_amount:amount,
      p_contract_assignment_id:employee.kind==='ABK'?st.assignment:null,
      p_description:String(fd.get('description')||'')||null,
      p_reference:null
    });
    if(error)return msg(error.message);
    await financeAdvancePage();
    msg('Kasbon '+(employee.kind==='ABK'?'ABK':'karyawan')+' berhasil disimpan.',true);
  };
}

async function financeAdvancePaymentPage(){
  const [vr,pr,er,ar,br,cr]=await Promise.all([
    db.from('advances').select('id,employee_id,contract_assignment_id,barn_id,advanced_on,amount,description,reference,created_at').order('advanced_on',{ascending:true}),
    db.from('advance_payments').select('id,advance_id,paid_on,amount,method,reference,notes,created_at').order('paid_on',{ascending:false}),
    db.from('employees').select('id,code,name'),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active'),
    db.from('barns').select('id,code,name'),
    db.from('contracts').select('id,number').is('cycle_id',null)
  ]);
  const advances=vr.data||[],payments=pr.data||[],employees=er.data||[],assignments=ar.data||[],barns=br.data||[],contractsRows=cr.data||[];
  const err=[vr,pr,er,ar,br,cr].find(x=>x.error)?.error;
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());
  const paid=id=>payments.filter(x=>x.advance_id===id).reduce((n,x)=>n+prodNum(x.amount),0);
  const open=advances.map(a=>({...a,balance:prodNum(a.amount)-paid(a.id)})).filter(a=>a.balance>0.0001);
  const emp=id=>{const e=employees.find(x=>x.id===id);return e?e.code+' · '+e.name:'-'};
  const ident=id=>{const a=assignments.find(x=>x.id===id);return a?assignmentIdentity(assignments,barns,contractsRows,a):'KARYAWAN UMUM';};

  let html='<section class="panel"><h3>Cicilan Kasbon</h3><p class="muted">Pembayaran kasbon berlaku untuk ABK maupun karyawan umum. Potongan otomatis dari menu Gaji ABK hanya berlaku untuk ABK.</p>'+
    '<form id="advancePaymentForm" class="form-vertical">'+
      '<label>Kasbon<select name="advance_id" required><option value="">Pilih Kasbon</option>'+open.map(a=>'<option value="'+esc(a.id)+'">'+esc(emp(a.employee_id)+' · '+ident(a.contract_assignment_id)+' · Sisa Rp '+prodFmt(a.balance,0))+'</option>').join('')+'</select></label>'+
      '<label>Tanggal Bayar<input name="paid_on" type="date" value="'+today+'" required></label>'+
      '<label>Nominal<input name="amount" type="text" inputmode="decimal" data-number="1" required></label>'+
      '<label>Metode<select name="method" required><option value="TUNAI">Tunai</option><option value="TRANSFER">Transfer</option></select></label>'+
      '<label>Catatan<input name="notes"></label>'+
      '<button type="submit">Simpan Cicilan</button>'+
    '</form></section>'+
    '<section class="panel" id="advancePaymentPrintArea"><div class="rhpp-section-head"><div><h3>Riwayat Cicilan / Potongan</h3></div><div class="report-actions"><button type="button" id="advancePaymentPrint">Cetak / PDF</button></div></div><div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>Karyawan</th><th>Kandang / Siklus</th><th>Metode</th><th>Nominal</th></tr></thead><tbody>'+
    payments.map(p=>{const a=advances.find(x=>x.id===p.advance_id);return '<tr><td>'+prodDateId(p.paid_on)+'</td><td>'+esc(emp(a?.employee_id))+'</td><td>'+esc(ident(a?.contract_assignment_id))+'</td><td>'+esc(p.method)+'</td><td>Rp '+prodFmt(p.amount,0)+'</td></tr>';}).join('')+
    '</tbody></table></div>'+(payments.length?'':'<p class="muted">Belum ada cicilan.</p>')+'</section>';
  layout(html);bindNumberInputs();if(err)msg(err.message);
  const advancePaymentPrint=document.getElementById('advancePaymentPrint');if(advancePaymentPrint)advancePaymentPrint.onclick=()=>printFinanceDocument('advancePaymentPrintArea','Riwayat Cicilan dan Potongan Kasbon');
  const form=document.getElementById('advancePaymentForm');
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();const fd=new FormData(form),id=String(fd.get('advance_id')||''),a=open.find(x=>x.id===id),amount=normalizeInputID(fd.get('amount'));
    if(!a)return msg('Pilih kasbon.');
    if(amount===null||amount<=0||amount>a.balance)return msg('Nominal cicilan tidak valid atau melebihi saldo.');
    const {error}=await db.from('advance_payments').insert({
      advance_id:id,paid_on:fd.get('paid_on'),amount,method:fd.get('method'),
      reference:null,notes:fd.get('notes')||null
    });
    if(error)return msg(error.message);
    await financeAdvancePaymentPage();msg('Cicilan kasbon berhasil disimpan.',true);
  };
}

async function financeSalaryPage(){
  const [br,ar,cr,lr,er,vr,pr,sr]=await Promise.all([
    db.from('barns').select('id,code,name').order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active,created_at').order('start_date',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('logistics_contract_assignment_abks').select('contract_assignment_id,abk_id'),
    db.from('employees').select('id,code,name,kind').eq('kind','ABK'),
    db.from('advances').select('id,employee_id,contract_assignment_id,amount,advanced_on,created_at'),
    db.from('advance_payments').select('advance_id,amount'),
    db.from('abk_cycle_salaries').select('*').order('paid_on',{ascending:false})
  ]);
  const barns=br.data||[],assignments=ar.data||[],contractsRows=cr.data||[],links=lr.data||[],employees=er.data||[],advances=vr.data||[],payments=pr.data||[],salaries=sr.data||[];
  const err=[br,ar,cr,lr,er,vr,pr,sr].find(x=>x.error)?.error;
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());
  window.__financeSalaryState=window.__financeSalaryState||{barn:'',assignment:'',abk:''};
  const st=window.__financeSalaryState;
  const cycles=st.barn?assignments.filter(a=>a.barn_id===st.barn):[];
  const abkIds=new Set(links.filter(x=>x.contract_assignment_id===st.assignment).map(x=>x.abk_id));
  const abks=employees.filter(e=>abkIds.has(e.id));
  const paid=id=>payments.filter(x=>x.advance_id===id).reduce((n,x)=>n+prodNum(x.amount),0);
  const balance=(abkId,assignmentId)=>advances.filter(a=>a.employee_id===abkId&&a.contract_assignment_id===assignmentId).reduce((n,a)=>n+Math.max(0,prodNum(a.amount)-paid(a.id)),0);
  const currentBalance=st.abk&&st.assignment?balance(st.abk,st.assignment):0;
  const emp=id=>{const e=employees.find(x=>x.id===id);return e?e.code+' · '+e.name:'-'};
  const ident=id=>{const a=assignments.find(x=>x.id===id);return a?assignmentIdentity(assignments,barns,contractsRows,a):'-';};

  let html='<section class="panel"><h3>Gaji ABK per Siklus</h3><p class="muted">Gaji bruto menjadi beban TENAGA KERJA pada BOP siklus. Potongan kasbon mengurangi saldo kasbon; kas keluar saat gajian hanya gaji bersih.</p>'+
    '<form id="salaryForm" class="form-vertical">'+
      '<label>Kandang<select id="salaryBarn" required><option value="">Pilih Kandang</option>'+barns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
      '<label>Siklus<select id="salaryCycle" required '+(!st.barn?'disabled':'')+'><option value="">Pilih Siklus</option>'+cycles.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('')+'</select></label>'+
      '<label>ABK<select id="salaryAbk" required '+(!st.assignment?'disabled':'')+'><option value="">Pilih ABK</option>'+abks.map(e=>'<option value="'+esc(e.id)+'" '+(st.abk===e.id?'selected':'')+'>'+esc(e.code+' · '+e.name)+'</option>').join('')+'</select></label>'+
      '<div class="rhpp-summary-card"><span>Saldo Kasbon Siklus</span><strong>Rp '+prodFmt(currentBalance,0)+'</strong></div>'+
      '<label>Gaji Bruto Siklus<input name="gross_salary" type="text" inputmode="decimal" data-number="1" required></label>'+
      '<label>Potongan Kasbon<input name="advance_deduction" type="text" inputmode="decimal" data-number="1" value="0"></label>'+
      '<label>Tanggal Bayar<input name="paid_on" type="date" value="'+today+'" required></label>'+
      '<label>Catatan<input name="notes"></label>'+
      '<button type="submit">Simpan Gaji Siklus</button>'+
    '</form></section>'+
    '<section class="panel" id="salaryPrintArea"><div class="rhpp-section-head"><div><h3>Riwayat Gaji ABK</h3></div><div class="report-actions"><button type="button" id="salaryPrint">Cetak / PDF</button></div></div><div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>Kandang / Siklus</th><th>ABK</th><th>Gaji Bruto</th><th>Potongan Kasbon</th><th>Gaji Dibayar</th></tr></thead><tbody>'+
      salaries.map(s=>'<tr><td>'+prodDateId(s.paid_on)+'</td><td>'+esc(ident(s.contract_assignment_id))+'</td><td>'+esc(emp(s.abk_id))+'</td><td>Rp '+prodFmt(s.gross_salary,0)+'</td><td>Rp '+prodFmt(s.advance_deduction,0)+'</td><td><strong>Rp '+prodFmt(s.net_paid,0)+'</strong></td></tr>').join('')+
    '</tbody></table></div>'+(salaries.length?'':'<p class="muted">Belum ada gaji ABK.</p>')+'</section>';
  layout(html);bindNumberInputs();if(err)msg(err.message);

  const salaryPrint=document.getElementById('salaryPrint');if(salaryPrint)salaryPrint.onclick=()=>printFinanceDocument('salaryPrintArea','Laporan Gaji ABK per Siklus');
  const b=document.getElementById('salaryBarn'),cy=document.getElementById('salaryCycle'),ab=document.getElementById('salaryAbk');
  if(b)b.onchange=async()=>{st.barn=b.value||'';st.assignment='';st.abk='';await financeSalaryPage();};
  if(cy)cy.onchange=async()=>{st.assignment=cy.value||'';st.abk='';await financeSalaryPage();};
  if(ab)ab.onchange=async()=>{st.abk=ab.value||'';await financeSalaryPage();};
  const form=document.getElementById('salaryForm');
  if(form)form.onsubmit=async ev=>{
    ev.preventDefault();
    if(!st.assignment||!st.abk)return msg('Pilih Kandang, Siklus, dan ABK.');
    const fd=new FormData(form),gross=normalizeInputID(fd.get('gross_salary')),ded=normalizeInputID(fd.get('advance_deduction'))||0;
    if(gross===null||gross<0)return msg('Gaji bruto tidak valid.');
    if(ded<0||ded>gross||ded>currentBalance)return msg('Potongan kasbon tidak valid.');
    const {error}=await db.rpc('finance_save_abk_salary_atomic',{
      p_contract_assignment_id:st.assignment,p_abk_id:st.abk,p_gross_salary:gross,p_advance_deduction:ded,
      p_paid_on:String(fd.get('paid_on')||''),p_reference:null,p_notes:String(fd.get('notes')||'')||null
    });
    if(error)return msg(error.message);
    st.abk='';
    await financeSalaryPage();msg('Gaji ABK per siklus berhasil disimpan.',true);
  };
}

async function financeCashflowPage(){
  const [xr,bar,assr,cr,cpr]=await Promise.all([
    db.rpc('finance_cashflow_entries_v1'),
    db.from('barns').select('id,code,name'),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active'),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('company_profile').select('company_name,legal_name,logo_url,address,phone,email').eq('id',true).maybeSingle()
  ]);
  const rows=(xr.data||[]).map(x=>({date:x.txn_date,type:x.txn_type,source:x.source,amount:prodNum(x.amount),barn_id:x.barn_id||'',assignment_id:x.contract_assignment_id||'',detail:x.detail||'',reference:x.reference||''})).sort((a,b)=>String(b.date||'').localeCompare(String(a.date||'')));
  const barns=bar.data||[],assignments=assr.data||[],company=cpr.data||{};
  const err=[xr,bar,assr,cr,cpr].find(x=>x.error)?.error;
  window.__financeCashflowState=window.__financeCashflowState||{from:'',to:'',barn:'',assignment:'',shown:false};
  const st=window.__financeCashflowState;
  const visible=rows.filter(x=>(!st.from||x.date>=st.from)&&(!st.to||x.date<=st.to)&&(!st.barn||x.barn_id===st.barn)&&(!st.assignment||x.assignment_id===st.assignment));
  const masuk=visible.filter(x=>x.type==='MASUK').reduce((n,x)=>n+x.amount,0),keluar=visible.filter(x=>x.type==='KELUAR').reduce((n,x)=>n+x.amount,0),saldo=masuk-keluar;

  let html='<section class="panel"><h3>Arus Kas Otomatis</h3><p class="muted"><strong>READ ONLY.</strong> Tidak ada input ulang di menu ini. Data ditarik otomatis dari transaksi sumber. Potongan gaji bukan kas masuk; gaji bruto tidak dicatat dua kali, dan saat gajian hanya gaji bersih yang menjadi kas keluar.</p>'+
    '<form id="cashflowFilter" class="form-vertical"><label>Tanggal Awal<input type="date" name="from" value="'+esc(st.from||'')+'"></label><label>Tanggal Akhir<input type="date" name="to" value="'+esc(st.to||'')+'"></label>'+
    '<label>Kandang<select name="barn"><option value="">Semua Kandang</option>'+barns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
    '<label>Siklus<select name="assignment" '+(!st.barn?'disabled':'')+'><option value="">Semua Siklus</option>'+assignments.filter(a=>a.barn_id===st.barn).map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('')+'</select></label><button type="submit">Tampilkan</button></form></section>';
  if(st.shown)html+='<section class="panel" id="cashflowPrintArea"><div class="rhpp-section-head"><div><h3>Ringkasan Arus Kas</h3></div><div class="report-actions"><button type="button" id="cashflowPrint">Cetak / PDF</button></div></div><div class="rhpp-summary-cards"><div class="rhpp-summary-card"><span>Kas Masuk</span><strong>Rp '+prodFmt(masuk,0)+'</strong></div><div class="rhpp-summary-card"><span>Kas Keluar</span><strong>Rp '+prodFmt(keluar,0)+'</strong></div><div class="rhpp-summary-card"><span>Saldo</span><strong>Rp '+prodFmt(saldo,0)+'</strong></div></div>'+
    '<div class="tablewrap"><table><thead><tr><th>Tanggal</th><th>Jenis</th><th>Sumber</th><th>Keterangan</th><th>Referensi</th><th>Masuk</th><th>Keluar</th></tr></thead><tbody>'+visible.map(x=>'<tr><td>'+prodDateId(x.date)+'</td><td>'+esc(x.type)+'</td><td>'+esc(x.source)+'</td><td>'+esc(x.detail)+'</td><td>'+esc(x.reference||'-')+'</td><td>'+(x.type==='MASUK'?'Rp '+prodFmt(x.amount,0):'-')+'</td><td>'+(x.type==='KELUAR'?'Rp '+prodFmt(x.amount,0):'-')+'</td></tr>').join('')+'</tbody></table></div>'+(visible.length?'':'<p class="muted">Tidak ada transaksi sesuai filter.</p>')+'</section>';
  layout(html);if(err)msg(err.message);const cashflowPrint=document.getElementById('cashflowPrint');if(cashflowPrint)cashflowPrint.onclick=()=>printFinanceDocument('cashflowPrintArea','Laporan Arus Kas Otomatis');
  const form=document.getElementById('cashflowFilter');
  if(form){form.elements.barn.onchange=async()=>{st.barn=form.elements.barn.value||'';st.assignment='';st.shown=false;await financeCashflowPage();};form.onsubmit=async ev=>{ev.preventDefault();const fd=new FormData(form);st.from=String(fd.get('from')||'');st.to=String(fd.get('to')||'');st.barn=String(fd.get('barn')||'');st.assignment=st.barn?String(fd.get('assignment')||''):'';if(st.from&&st.to&&st.from>st.to){const t=st.from;st.from=st.to;st.to=t}st.shown=true;await financeCashflowPage();};}
}

async function financeReportPage(){
  const [xr,ar,br,cr,cpr,companyR,expR]=await Promise.all([
    db.rpc('finance_cycle_profit_loss_v1'),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active'),
    db.from('barns').select('id,code,name'),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('company_profile').select('company_name,legal_name,logo_url,address,phone,email').eq('id',true).maybeSingle(),
    db.rpc('finance_company_profit_loss_v1'),
    db.rpc('finance_expedition_profit_loss_v1')
  ]);
  const rows=xr.data||[],assignments=ar.data||[],barns=br.data||[],contractsRows=cr.data||[],company=cpr.data||{};
  const companyRow=(companyR.data||[])[0]||{},expRow=(expR.data||[])[0]||{};
  const err=[xr,ar,br,cr,cpr,companyR,expR].find(x=>x.error)?.error;
  window.__financeReportState=window.__financeReportState||{barn:'',assignment:'',shown:false};
  const st=window.__financeReportState;
  const visible=st.shown?rows.filter(x=>(!st.barn||x.barn_id===st.barn)&&(!st.assignment||x.contract_assignment_id===st.assignment)):[];
  const total=k=>visible.reduce((n,x)=>n+prodNum(x[k]),0);
  const real=total('rhpp_real'),bop=total('bop_kandang'),sap=total('sapronak_luar'),meat=total('tambah_daging'),profit=total('laba_rugi_real');

  let html='<section class="panel"><h3>Laporan Keuangan / Laba Rugi Riil</h3><p class="muted"><strong>OTOMATIS / READ ONLY.</strong> Tidak ada input ulang angka laporan. Hitungan PUTUS per Kandang + Siklus. RHPP Sistem hanya pembanding. Dasar laba/rugi: RHPP Real − BOP Kandang − Sapronak Luar − Tambah Daging.</p>'+
    '<form id="financeReportFilter" class="form-vertical"><label>Kandang<select name="barn"><option value="">Semua Kandang</option>'+barns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
    '<label>Siklus<select name="assignment" '+(!st.barn?'disabled':'')+'><option value="">Semua Siklus</option>'+assignments.filter(a=>a.barn_id===st.barn).map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'PROSES':'CLOSED'))+'</option>').join('')+'</select></label><button type="submit">Tampilkan</button></form></section>';
  if(st.shown){
    html+='<section class="panel" id="companyProfitPrintArea"><div class="rhpp-section-head"><div><h3>Laba / Rugi Perusahaan</h3></div><div class="report-actions"><button type="button" id="financeReportPrint">Cetak / PDF</button></div></div><div class="rhpp-summary-cards"><div class="rhpp-summary-card"><span>Laba/Rugi Kandang</span><strong>Rp '+prodFmt(companyRow.kandang_profit_loss||0,0)+'</strong></div><div class="rhpp-summary-card"><span>Pendapatan Expedisi</span><strong>Rp '+prodFmt(companyRow.expedition_revenue||0,0)+'</strong></div><div class="rhpp-summary-card"><span>BOP Expedisi</span><strong>Rp '+prodFmt(companyRow.expedition_bop||0,0)+'</strong></div><div class="rhpp-summary-card"><span>Laba/Rugi Expedisi</span><strong>Rp '+prodFmt(companyRow.expedition_profit_loss||0,0)+'</strong></div><div class="rhpp-summary-card"><span>BOP Umum</span><strong>Rp '+prodFmt(companyRow.bop_umum||0,0)+'</strong></div><div class="rhpp-summary-card"><span>Laba/Rugi Perusahaan</span><strong>Rp '+prodFmt(companyRow.company_profit_loss||0,0)+'</strong></div></div><p class="muted">Piutang Expedisi: Rp '+prodFmt(expRow.expedition_receivable||0,0)+' · Kas diterima Expedisi: Rp '+prodFmt(expRow.expedition_cash_received||0,0)+'</p></section><section class="panel" id="cycleSummaryPrintArea"><h3>Ringkasan Riil</h3><div class="rhpp-summary-cards"><div class="rhpp-summary-card"><span>RHPP Real</span><strong>Rp '+prodFmt(real,0)+'</strong></div><div class="rhpp-summary-card"><span>BOP Kandang</span><strong>Rp '+prodFmt(bop,0)+'</strong></div><div class="rhpp-summary-card"><span>Sapronak Luar</span><strong>Rp '+prodFmt(sap,0)+'</strong></div><div class="rhpp-summary-card"><span>Tambah Daging</span><strong>Rp '+prodFmt(meat,0)+'</strong></div><div class="rhpp-summary-card"><span>Laba / Rugi Riil</span><strong>Rp '+prodFmt(profit,0)+'</strong></div></div></section>'+
    '<section class="panel" id="cycleProfitPrintArea"><h3>Laba/Rugi Putus per Siklus</h3><div class="tablewrap"><table><thead><tr><th>Kandang / Siklus</th><th>Status</th><th>RHPP Sistem</th><th>RHPP Real</th><th>BOP</th><th>Gaji ABK</th><th>Sapronak Luar</th><th>Tambah Daging</th><th>Kasbon Berjalan</th><th>Laba/Rugi Riil</th></tr></thead><tbody>'+
    visible.map(x=>{const a=assignments.find(v=>v.id===x.contract_assignment_id);return '<tr><td>'+esc(a?assignmentIdentity(assignments,barns,contractsRows,a):(x.barn_code+' · '+x.barn_name))+'</td><td>'+(x.active?'PROSES':'CLOSED')+'</td><td>Rp '+prodFmt(x.rhpp_system,0)+'</td><td>Rp '+prodFmt(x.rhpp_real,0)+'</td><td>Rp '+prodFmt(x.bop_kandang,0)+'</td><td>Rp '+prodFmt(x.gaji_abk,0)+'</td><td>Rp '+prodFmt(x.sapronak_luar,0)+'</td><td>Rp '+prodFmt(x.tambah_daging,0)+'</td><td>Rp '+prodFmt(x.saldo_kasbon,0)+'</td><td><strong>Rp '+prodFmt(x.laba_rugi_real,0)+'</strong></td></tr>';}).join('')+
    '</tbody></table></div>'+(visible.length?'':'<p class="muted">Tidak ada data sesuai filter.</p>')+'</section>';
  }
  layout(html);if(err)msg(err.message);const financeReportPrint=document.getElementById('financeReportPrint');if(financeReportPrint)financeReportPrint.onclick=()=>printFinanceDocument(['companyProfitPrintArea','cycleSummaryPrintArea','cycleProfitPrintArea'],'Laporan Keuangan dan Laba Rugi');
  const form=document.getElementById('financeReportFilter');
  if(form){form.elements.barn.onchange=async()=>{st.barn=form.elements.barn.value||'';st.assignment='';st.shown=false;await financeReportPage();};form.onsubmit=async ev=>{ev.preventDefault();const fd=new FormData(form);st.barn=String(fd.get('barn')||'');st.assignment=st.barn?String(fd.get('assignment')||''):'';st.shown=true;await financeReportPage();};}
}

async function barnMasterPage(){
  const m=modules.kandang;
  const {data,error}=await db.from('barns').select('*').order('code',{ascending:true});
  const rows=data||[];
  const kinds=[...new Set(rows.map(x=>String(x.kind||'').trim()).filter(Boolean))].sort();

  let html='<section class="panel"><h3>Tambah / Edit '+title.kandang+'</h3>'+
    '<form id="barnMasterEntry" class="form-vertical">'+
      '<input type="hidden" name="id">'+
      m.fields.map(field).join('')+
      '<div class="report-actions"><button type="submit" id="barnMasterSave">Simpan</button><button type="button" id="barnMasterCancel" hidden>Batal Edit</button></div>'+
    '</form></section>'+
    '<section class="panel"><h3>Data '+title.kandang+'</h3>'+
      '<form id="barnMasterFilter" class="form-vertical">'+
        '<label>Kode<input name="code" placeholder="Contoh: KD-001"></label>'+
        '<label>Nama<input name="name" placeholder="Nama kandang"></label>'+
        '<label>Kapasitas Minimum<input name="capacity_min" type="text" inputmode="numeric" data-number="1" placeholder="Contoh: 8000"></label>'+
        '<label>Kapasitas Maksimum<input name="capacity_max" type="text" inputmode="numeric" data-number="1" placeholder="Contoh: 40000"></label>'+
        '<label>Jenis<select name="kind"><option value="">Semua Jenis</option>'+kinds.map(x=>'<option value="'+esc(x)+'">'+esc(x)+'</option>').join('')+'</select></label>'+
        '<label>Lokasi<input name="location" placeholder="Cari lokasi"></label>'+
        '<div class="report-actions"><button type="submit">Tampilkan</button><button type="button" id="barnMasterFilterReset">Reset Filter</button></div>'+
      '</form>'+
      '<div id="barnMasterResult"><p class="muted">Pilih filter lalu tekan Tampilkan.</p></div>'+
    '</section>';

  layout(html);
  bindNumberInputs();

  const entry=document.getElementById('barnMasterEntry');
  const save=document.getElementById('barnMasterSave');
  const cancel=document.getElementById('barnMasterCancel');
  const filter=document.getElementById('barnMasterFilter');
  const result=document.getElementById('barnMasterResult');

  const resetEntry=()=>{
    entry.reset();
    entry.elements.id.value='';
    save.textContent='Simpan';
    cancel.hidden=true;
  };
  cancel.onclick=resetEntry;

  const renderRows=filtered=>{
    result.innerHTML=filtered.length
      ?'<div class="tablewrap"><table><thead><tr><th>Kode</th><th>Nama</th><th>Kapasitas</th><th>Jenis</th><th>Lokasi</th><th>Aksi</th></tr></thead><tbody>'+
        filtered.map(x=>'<tr><td>'+esc(x.code||'')+'</td><td>'+esc(x.name||'')+'</td><td>'+fmtNumber(x.capacity||0)+'</td><td>'+esc(x.kind||'')+'</td><td>'+esc(x.location||'-')+'</td><td><button type="button" data-edit-barn="'+esc(x.id)+'">Edit</button></td></tr>').join('')+
        '</tbody></table></div>'
      :'<p class="muted">Data tidak ditemukan.</p>';

    result.querySelectorAll('[data-edit-barn]').forEach(btn=>btn.onclick=()=>{
      const x=rows.find(v=>v.id===btn.dataset.editBarn);
      if(!x)return;
      entry.elements.id.value=x.id;
      for(const [key] of m.fields){
        if(entry.elements[key])entry.elements[key].value=x[key]??'';
      }
      save.textContent='Simpan Perubahan';
      cancel.hidden=false;
      entry.scrollIntoView({behavior:'smooth',block:'start'});
    });
  };

  filter.onsubmit=ev=>{
    ev.preventDefault();
    const fd=new FormData(filter);
    const code=String(fd.get('code')||'').trim().toLowerCase();
    const name=String(fd.get('name')||'').trim().toLowerCase();
    const minCap=normalizeInputID(fd.get('capacity_min'));
    const maxCap=normalizeInputID(fd.get('capacity_max'));
    const kind=String(fd.get('kind')||'');
    const location=String(fd.get('location')||'').trim().toLowerCase();

    const filtered=rows.filter(x=>
      (!code||String(x.code||'').toLowerCase().includes(code))&&
      (!name||String(x.name||'').toLowerCase().includes(name))&&
      (minCap==null||Number(x.capacity||0)>=minCap)&&
      (maxCap==null||Number(x.capacity||0)<=maxCap)&&
      (!kind||String(x.kind||'')===kind)&&
      (!location||String(x.location||'').toLowerCase().includes(location))
    );
    renderRows(filtered);
  };

  document.getElementById('barnMasterFilterReset').onclick=()=>{
    filter.reset();
    result.innerHTML='<p class="muted">Pilih filter lalu tekan Tampilkan.</p>';
  };

  entry.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(entry);
    const id=String(fd.get('id')||'');
    const payload={};
    for(const [k,,t] of m.fields){
      let v=fd.get(k);
      if(v!==''&&v!=null){
        const nv=t==='number'?normalizeInputID(v):v;
        if(nv!==null)payload[k]=nv;
      }else payload[k]=null;
    }

    const q=id
      ?db.from('barns').update(payload).eq('id',id)
      :db.from('barns').insert(payload);
    const {error:saveError}=await q;
    if(saveError)return msg(saveError.message);
    legacyDataLoaded=false;
    dashboardDataLoaded=false;
    await barnMasterPage();
    msg(id?'Master Kandang diperbarui.':'Master Kandang tersimpan.',true);
  };

  if(error)msg(error.message);
}

async function itemMasterPage(){
  await ensureLegacyData();
  const m=modules.item;
  const {data,error}=await db.from('items').select('*').order('code',{ascending:true});
  const rows=data||[];
  const supplierRows=suppliers.filter(x=>x.supplier_type==='SAPRONAK');
  const phases=[...new Set(rows.map(x=>String(x.feed_phase||'').trim()).filter(Boolean))].sort();
  const units=[...new Set(rows.map(x=>String(x.unit||'').trim()).filter(Boolean))].sort();

  let html='<section class="panel"><h3>Tambah / Edit '+title.item+'</h3>'+
    '<form id="itemMasterEntry" class="form-vertical">'+
      '<input type="hidden" name="id">'+
      m.fields.map(field).join('')+
      '<div class="report-actions"><button type="submit" id="itemMasterSave">Simpan</button><button type="button" id="itemMasterCancel" hidden>Batal Edit</button></div>'+
    '</form></section>'+
    '<section class="panel"><h3>Data '+title.item+'</h3>'+
      '<form id="itemMasterFilter" class="form-vertical">'+
        '<label>Kode<input name="code" placeholder="Contoh: SP-001"></label>'+
        '<label>Nama<input name="name" placeholder="Nama sapronak"></label>'+
        '<label>Kategori<select name="category"><option value="">Semua Kategori</option><option value="DOC">DOC</option><option value="PAKAN">PAKAN</option><option value="OVK">OVK</option><option value="LAINNYA">LAINNYA</option></select></label>'+
        '<label>Fase Pakan<select name="feed_phase"><option value="">Semua Fase Pakan</option>'+phases.map(x=>'<option value="'+esc(x)+'">'+esc(x)+'</option>').join('')+'</select></label>'+
        '<label>Satuan<select name="unit"><option value="">Semua Satuan</option>'+units.map(x=>'<option value="'+esc(x)+'">'+esc(x)+'</option>').join('')+'</select></label>'+
        '<label>Supplier<select name="supplier_id"><option value="">Semua Supplier</option>'+supplierRows.map(x=>'<option value="'+esc(x.id)+'">'+esc(x.name||x.code||'-')+'</option>').join('')+'</select></label>'+
        '<div class="report-actions"><button type="submit">Tampilkan</button><button type="button" id="itemMasterFilterReset">Reset Filter</button></div>'+
      '</form>'+
      '<div id="itemMasterResult"><p class="muted">Pilih filter lalu tekan Tampilkan.</p></div>'+
    '</section>';

  layout(html);
  bindNumberInputs();

  const entry=document.getElementById('itemMasterEntry');
  const save=document.getElementById('itemMasterSave');
  const cancel=document.getElementById('itemMasterCancel');
  const filter=document.getElementById('itemMasterFilter');
  const result=document.getElementById('itemMasterResult');

  const syncUnit=()=>{
    const cat=entry.elements.category;
    const unit=entry.elements.unit;
    if(!cat||!unit)return;
    if(!document.getElementById('ovk-units')){
      const dl=document.createElement('datalist');
      dl.id='ovk-units';
      ['BOTOL','SACHET','LITER','ML','GRAM','KG','VIAL','AMPUL','TABLET','DOS'].forEach(v=>{
        const o=document.createElement('option');o.value=v;dl.appendChild(o);
      });
      entry.appendChild(dl);
    }
    const apply=()=>{
      unit.removeAttribute('list');
      unit.placeholder='';
      if(cat.value==='DOC'){unit.value='EKOR';unit.readOnly=true;}
      else if(cat.value==='PAKAN'){unit.value='ZAK';unit.readOnly=true;}
      else if(cat.value==='OVK'){
        if(unit.readOnly)unit.value='';
        unit.readOnly=false;unit.setAttribute('list','ovk-units');unit.placeholder='Pilih/ketik satuan OVK';
      }else{
        if(unit.readOnly)unit.value='';
        unit.readOnly=false;unit.placeholder='Masukkan satuan';
      }
    };
    cat.addEventListener('change',apply);apply();
  };
  syncUnit();

  const resetEntry=()=>{
    entry.reset();
    entry.elements.id.value='';
    save.textContent='Simpan';
    cancel.hidden=true;
    syncUnit();
  };
  cancel.onclick=resetEntry;

  const renderRows=filtered=>{
    result.innerHTML=filtered.length
      ?'<div class="tablewrap"><table><thead><tr><th>Kode</th><th>Nama</th><th>Kategori</th><th>Fase Pakan</th><th>Satuan</th><th>Supplier</th><th>Aksi</th></tr></thead><tbody>'+
        filtered.map(x=>{
          const sup=supplierRows.find(v=>v.id===x.supplier_id);
          return '<tr><td>'+esc(x.code||'')+'</td><td>'+esc(x.name||'')+'</td><td>'+esc(x.category||'')+'</td><td>'+esc(x.feed_phase||'-')+'</td><td>'+esc(x.unit||'')+'</td><td>'+esc(sup?.name||'-')+'</td><td><button type="button" data-edit-item="'+esc(x.id)+'">Edit</button></td></tr>';
        }).join('')+
        '</tbody></table></div>'
      :'<p class="muted">Data tidak ditemukan.</p>';

    result.querySelectorAll('[data-edit-item]').forEach(btn=>btn.onclick=()=>{
      const x=rows.find(v=>v.id===btn.dataset.editItem);
      if(!x)return;
      entry.elements.id.value=x.id;
      for(const [key] of m.fields){
        if(entry.elements[key])entry.elements[key].value=x[key]??'';
      }
      save.textContent='Simpan Perubahan';
      cancel.hidden=false;
      syncUnit();
      entry.scrollIntoView({behavior:'smooth',block:'start'});
    });
  };

  filter.onsubmit=ev=>{
    ev.preventDefault();
    const fd=new FormData(filter);
    const code=String(fd.get('code')||'').trim().toLowerCase();
    const name=String(fd.get('name')||'').trim().toLowerCase();
    const category=String(fd.get('category')||'');
    const phase=String(fd.get('feed_phase')||'');
    const unit=String(fd.get('unit')||'');
    const supplierId=String(fd.get('supplier_id')||'');
    const filtered=rows.filter(x=>
      (!code||String(x.code||'').toLowerCase().includes(code))&&
      (!name||String(x.name||'').toLowerCase().includes(name))&&
      (!category||String(x.category||'')===category)&&
      (!phase||String(x.feed_phase||'')===phase)&&
      (!unit||String(x.unit||'')===unit)&&
      (!supplierId||String(x.supplier_id||'')===supplierId)
    );
    renderRows(filtered);
  };

  document.getElementById('itemMasterFilterReset').onclick=()=>{
    filter.reset();
    result.innerHTML='<p class="muted">Pilih filter lalu tekan Tampilkan.</p>';
  };

  entry.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(entry);
    const id=String(fd.get('id')||'');
    const payload={};
    for(const [k,,t] of m.fields){
      let v=fd.get(k);
      if(v!==''&&v!=null){
        const nv=t==='number'?normalizeInputID(v):v;
        if(nv!==null)payload[k]=nv;
      }else payload[k]=null;
    }
    const q=id
      ?db.from('items').update(payload).eq('id',id)
      :db.from('items').insert(payload);
    const {error:saveError}=await q;
    if(saveError)return msg(saveError.message);
    legacyDataLoaded=false;
    await itemMasterPage();
    msg(id?'Master Sapronak diperbarui.':'Master Sapronak tersimpan.',true);
  };

  if(error)msg(error.message);
}


async function adminDataArchivePage(){
  if(profile?.role!=='ADMIN')return layout('<section class="panel"><h3>Akses Dikunci</h3><p class="muted">Hanya Administrator yang dapat mengekspor seluruh data.</p></section>');

  const tableNames=[
    'profiles','barns','cycles','contracts','items','chick_ins','supplies','recordings','visits','harvests','rhpp_real','bop',
    'audit_events','company_profile','employees','advances','advance_payments','expeditions','rhpp_estimates','contract_live_prices',
    'contract_bonuses','performance_standards','logistics_contract_assignments','logistics_shipments','logistics_shipment_items',
    'logistics_returns','logistics_return_items','suppliers','logistics_external_shipments','logistics_external_shipment_items',
    'marketing_external_meat_purchases','marketing_contract_harvests','logistics_contract_assignment_abks','recording_weight_samples',
    'production_estimates','production_estimate_sizes','production_abk_results','production_abk_result_sizes','logistics_external_returns',
    'logistics_external_return_items','logistics_external_return_transfers','rhpp_system_final','bop_outside','abk_league_settings',
    'abk_cycle_salaries','finance_expedition_trips','finance_expedition_invoices','finance_expedition_invoice_items',
    'finance_expedition_payments','finance_expedition_bop','finance_reference_counters'
  ];

  layout('<section class="panel"><h3>Arsip Data</h3>'+
    '<p class="muted">Export seluruh data BMS ke satu file Excel. Proses ini hanya membaca data dan tidak menghapus atau mengubah database.</p>'+
    '<div class="inline-actions"><button type="button" id="exportAllDataBtn">Export Semua Data</button></div>'+
    '<p id="exportAllDataStatus" class="muted"></p></section>');

  const btn=document.getElementById('exportAllDataBtn');
  const status=document.getElementById('exportAllDataStatus');
  if(!btn)return;

  const excelText=v=>{
    if(v===null||v===undefined)return '';
    if(typeof v==='object'){
      try{return JSON.stringify(v);}catch{return String(v);}
    }
    return String(v);
  };
  const htmlEsc=v=>excelText(v).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');

  const fetchAll=async table=>{
    const all=[];
    const pageSize=1000;
    for(let from=0;;from+=pageSize){
      const {data,error}=await db.from(table).select('*').range(from,from+pageSize-1);
      if(error)throw new Error(table+': '+error.message);
      const rows=data||[];
      all.push(...rows);
      if(rows.length<pageSize)break;
    }
    return all;
  };

  btn.onclick=async()=>{
    btn.disabled=true;
    status.textContent='Menyiapkan seluruh data...';
    try{
      const sections=[];
      let totalRows=0;
      for(let i=0;i<tableNames.length;i++){
        const table=tableNames[i];
        status.textContent='Mengambil '+table+' ('+(i+1)+'/'+tableNames.length+')...';
        const rows=await fetchAll(table);
        totalRows+=rows.length;
        const cols=[...new Set(rows.flatMap(r=>Object.keys(r||{})))];
        let body='<h2>'+htmlEsc(table)+'</h2><p>Jumlah data: '+rows.length+'</p>';
        if(!rows.length){
          body+='<table border="1"><tr><td>Tidak ada data</td></tr></table>';
        }else{
          body+='<table border="1" cellspacing="0" cellpadding="3"><thead><tr>'+
            cols.map(c=>'<th style="background:#d9eaf7">'+htmlEsc(c)+'</th>').join('')+
            '</tr></thead><tbody>'+
            rows.map(r=>'<tr>'+cols.map(c=>'<td>'+htmlEsc(r[c])+'</td>').join('')+'</tr>').join('')+
            '</tbody></table>';
        }
        sections.push(body);
      }

      const now=new Date();
      const y=now.getFullYear(),m=String(now.getMonth()+1).padStart(2,'0'),d=String(now.getDate()).padStart(2,'0');
      const fileName='BMS_EXPORT_SEMUA_DATA_'+y+'-'+m+'-'+d+'.xls';
      const html='\ufeff<html><head><meta charset="utf-8"><title>'+fileName+'</title>'+
        '<style>body{font-family:Arial,sans-serif;font-size:10px}h1{color:#173f6b}h2{margin-top:24px;background:#173f6b;color:#fff;padding:6px}table{border-collapse:collapse;margin-bottom:18px}th,td{vertical-align:top;white-space:nowrap}</style>'+
        '</head><body><h1>BMS Mobile - Export Semua Data</h1>'+
        '<p>Tanggal export: '+htmlEsc(now.toLocaleString('id-ID'))+'</p>'+
        '<p>Total tabel: '+tableNames.length+' | Total baris: '+totalRows+'</p>'+
        sections.join('')+'</body></html>';

      const blob=new Blob([html],{type:'application/vnd.ms-excel;charset=utf-8'});
      const url=URL.createObjectURL(blob);
      const a=document.createElement('a');
      a.href=url;a.download=fileName;document.body.appendChild(a);a.click();a.remove();
      setTimeout(()=>URL.revokeObjectURL(url),1500);
      status.textContent='Export selesai: '+tableNames.length+' tabel, '+totalRows+' baris.';
      msg('Export seluruh data berhasil.',true);
    }catch(error){
      status.textContent='Export gagal: '+(error?.message||'tidak diketahui');
      msg('Export gagal: '+(error?.message||'tidak diketahui'));
    }finally{
      btn.disabled=false;
    }
  };
}

async function render(){if(!canViewTab(tab))return layout('<section class="panel"><h3>Akses Dikunci</h3><p class="muted">Menu ini terlihat pada semua akun, tetapi akun '+esc(profile.role)+' tidak memiliki hak akses untuk membukanya.</p></section>');if(['owner_logistics_report','owner_marketing_report','owner_finance_report','owner_production_report','owner_ppl_report'].includes(tab)&&['OWNER','ADMIN'].includes(profile.role))return ownerReportPendingPage();if(tab==='dashboard')return dashboard();if(tab==='kandang')return barnMasterPage();if(tab==='item')return itemMasterPage();if(tab==='supplier_sapronak')return supplierMasterPage('SAPRONAK');if(tab==='supplier_daging')return supplierMasterPage('DAGING');if(tab==='logistik_kontrak')return logisticsContractPage();if(tab==='logistik_pengiriman')return logisticsShippingPage();if(tab==='logistik_kiriman_luar')return logisticsExternalShippingPage();if(tab==='marketing_panen_kontrak')return marketingContractHarvestPage();if(tab==='marketing_tambah_daging')return marketingExternalMeatPage();if(tab==='marketing_laporan')return marketingReports();if(tab==='logistik_retur')return logisticsReturnPage();if(tab==='logistik_retur_luar')return logisticsExternalReturnPage();if(tab==='kontrak')return contractMasterPage();if(tab==='standar_performa')return performanceMasterPage();if(tab==='reset_klasemen')return resetKlasemenAbkPage();if(tab==='karyawan')return employeeMasterPage();if(tab==='profil')return profilePage();if(tab==='perusahaan')return companyProfilePage();if(tab==='arsip_data')return adminDataArchivePage();if(tab==='logistik_laporan')return logisticsReports();if(tab==='chick_in')return chickInPage();if(tab==='recording')return recordingPplPage();if(tab==='kunjungan')return productionVisitPage();if(tab==='estimasi')return productionEstimatePage();if(tab==='liga_abk')return leagueAbkPage();if(tab==='rekap_produksi')return productionRecapPage();if(tab==='ppl_rhpp_view')return pplRhppViewPage();if(tab==='rhpp_history')return adminRhppHistoryPage();if(tab==='rhpp')return profile.role==='ADMIN'?financeRhppPage():profile.role==='OWNER'?ownerProfitLossPage():financeRhppRealPage();if(tab==='finance_rhpp_real')return financeRhppRealPage();if(tab==='bop')return financeBopPage();if(tab==='bop_umum')return financeBopGeneralPage();if(tab==='expedisi_usaha')return financeExpeditionBusinessPage();if(tab==='bop_expedisi')return financeExpeditionBopPage();if(tab==='gaji_abk')return financeSalaryPage();if(tab==='kasbon')return financeAdvancePage();if(tab==='cicilan')return financeAdvancePaymentPage();if(tab==='arus_kas')return financeCashflowPage();if(tab==='laporan_keuangan')return financeReportPage();if(tab==='laporan'&&profile.role==='LOGISTIK')return logisticsReports();if(tab==='laporan')return reports();if(tab==='pengguna')return users();await ensureLegacyData();const m=modules[tab],can=roles[tab].includes(profile.role);const {data,error}=await db.from(m.table).select('*').limit(1000).order(tab==='kandang'?'created_at':tab==='siklus'?'created_at':tab==='sapronak'?'created_at':tab==='rhpp'?'created_at':'id',{ascending:false});const rows=data||[];const dateField=(m.fields.find(f=>f[2]==='date')||[])[0]||null;const txnGeneric=dateField?txnListState(rows,'generic_'+tab,dateField,5):null;const displayRows=txnGeneric?txnGeneric.rows:rows;let html=['kontrak','harga_hidup','bonus_kontrak','standar_performa'].includes(tab)?'<p>Masukkan angka dari kontrak yang ditandatangani. Periksa ulang foto acuan sebelum menyimpan harga atau ambang performa.</p>':'';html+=can?'<section class="panel"><h3>Tambah '+title[tab]+'</h3><form id="entry">'+m.fields.map(field).join('')+(tab==='kontrak'?'<button type="button" id="fillPhoto">Isi harga sapronak dari foto</button>':'')+'<button>Simpan</button></form></section>':'';if(tab==='kontrak'){html+='<section class="panel"><h3>Status Kelengkapan Kontrak</h3><div class="tablewrap"><table><tr><th>Kontrak</th><th>Status</th><th>Komponen kurang</th></tr>'+contractReadiness.map(x=>'<tr><td>'+esc(x.number)+'</td><td>'+(x.is_complete?'Lengkap':'Belum Lengkap')+'</td><td>'+esc((x.missing_components||[]).join(', ')||'-')+'</td></tr>').join('')+'</table></div>'+(!contractReadiness.length?'<p>Belum ada kontrak.</p>':'')+'</section>';}{const displayFields=(autoCodeTabs.has(tab)?[['code','Kode'],...m.fields]:m.fields).slice(0,6);html+='<section class="panel"><h3>Data '+title[tab]+'</h3>'+(txnGeneric?txnGeneric.controls:'')+'<div class="tablewrap"><table><thead><tr>'+displayFields.map(f=>'<th>'+f[1]+'</th>').join('')+'</tr></thead><tbody>'+displayRows.map(row=>'<tr>'+displayFields.map(f=>'<td>'+cellValue(row,f)+'</td>').join('')+'</tr>').join('')+'</tbody></table></div>'+(!(txnGeneric?txnGeneric.total:rows.length)?'<p>Belum ada data.</p>':'')+(txnGeneric?txnGeneric.pager:'')+'</section>';}layout(html);bindNumberInputs();bindComputedWeights();bindItemUnit();if(txnGeneric)bindTxnList(txnGeneric,()=>render());if(error)msg(error.message);if(tab==='kontrak'&&can)document.getElementById('fillPhoto').onclick=()=>{const f=document.getElementById('entry');for(const [k,v] of Object.entries({doc_price:9000,pre_starter_price:10350,starter_price:10100,finisher_price:10000,ovk_price_basis:'DISTRIBUTOR_PLUS_VAT'}))f.elements[k].value=v;msg('Harga sapronak dari foto terisi. Verifikasi kontrak dan isi persentase PPN sebelum menyimpan.',true)};if(can)document.getElementById('entry').onsubmit=async e=>{e.preventDefault();let o={};for(const [k,,t] of m.fields){let v=new FormData(e.target).get(k);if(v!==''&&v!=null){const nv=t==='number'?normalizeInputID(v):v;if(nv!==null)o[k]=nv}}const {error}=tab==='perusahaan'?await db.from(m.table).upsert({id:true,...o}):await db.from(m.table).insert(o);if(error)msg(error.message);else {await load();msg('Data tersimpan.',true)}}}
async function financeRhppRealPage(){
  const [sr,rr,ar,br,cr]=await Promise.all([
    db.from('rhpp_system_final').select('*').order('created_at',{ascending:false}),
    db.from('rhpp_real').select('*').order('created_at',{ascending:false}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active'),
    db.from('barns').select('id,code,name'),
    db.from('contracts').select('id,number').is('cycle_id',null)
  ]);
  const systems=sr.data||[],reals=rr.data||[],assignments=ar.data||[],barns=br.data||[],contractsRows=cr.data||[];
  const err=[sr,rr,ar,br,cr].find(x=>x.error)?.error;
  const canInput=['ADMIN','KEUANGAN'].includes(profile.role);
  const today=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Jakarta',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());

  window.__financeRhppRealState=window.__financeRhppRealState||{selected:'',barn:'',assignment:'',status:'',shown:false};
  const st=window.__financeRhppRealState;
  if(st.barn===undefined)st.barn='';
  if(st.assignment===undefined)st.assignment='';

  let cards=systems.map(s=>{
    const a=assignments.find(x=>x.id===s.contract_assignment_id);
    const b=barns.find(x=>x.id===s.barn_id);
    const k=contractsRows.find(x=>x.id===a?.master_contract_id);
    const real=reals.find(x=>x.contract_assignment_id===s.contract_assignment_id);
    const diff=real?prodNum(real.amount)-prodNum(s.system_amount):null;
    const diffLabel=diff===null?'MENUNGGU':diff===0?'SESUAI':diff>0?'REAL LEBIH BESAR':'REAL LEBIH KECIL';
    return {s,a,b,k,real,diff,diffLabel};
  });

  cards=cards.filter(x=>{
    if(st.barn&&x.s.barn_id!==st.barn)return false;
    if(st.assignment&&x.s.contract_assignment_id!==st.assignment)return false;
    if(st.status==='WAITING'&&x.real)return false;
    if(st.status==='DONE'&&!x.real)return false;
    return true;
  });
  const rhppBarns=[...new Map(systems.map(s=>{const b=barns.find(x=>x.id===s.barn_id);return b?[b.id,b]:null}).filter(Boolean)).values()];
  const rhppCycles=st.barn?assignments.filter(a=>a.barn_id===st.barn&&systems.some(s=>s.contract_assignment_id===a.id)):[];

  if(st.selected&&!systems.some(x=>x.contract_assignment_id===st.selected)){
    st.selected='';
  }

  let html='<section class="panel"><h3>RHPP Real Keuangan</h3><p class="muted">Data CLOSED wajib dipilih berdasarkan Kandang dan Siklus agar periode tidak tertukar.</p>'+
    '<form id="rhppRealFilter" class="form-vertical">'+
      '<label>Kandang<select name="barn" id="rhppRealBarn" required><option value="">Pilih Kandang</option>'+rhppBarns.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
      '<label>Siklus<select name="assignment" id="rhppRealCycle" required '+(!st.barn?'disabled':'')+'><option value="">Pilih Siklus</option>'+rhppCycles.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date))+'</option>').join('')+'</select></label>'+
      '<label>Status<select name="status"><option value="" '+(!st.status?'selected':'')+'>Semua</option><option value="WAITING" '+(st.status==='WAITING'?'selected':'')+'>Menunggu Input</option><option value="DONE" '+(st.status==='DONE'?'selected':'')+'>Sudah Input</option></select></label>'+
      '<button type="submit">Tampilkan</button>'+
    '</form></section>';

  if(!systems.length){
    html+='<section class="panel"><p>Belum ada RHPP Sistem Final dari Administrator.</p></section>';
    layout(html);if(err)msg(err.message);return;
  }

  if(st.shown)html+='<section class="panel"><h3>Daftar RHPP Real</h3>'+
    '<div class="tablewrap"><table><thead><tr><th>Kandang</th><th>Kontrak</th><th>Close Sistem</th><th>RHPP Sistem</th><th>Status Real</th><th>Selisih</th><th>Aksi</th></tr></thead><tbody>'+
    cards.map(x=>'<tr>'+
      '<td>'+esc(x.b?shortBarnLabel(x.b):'-')+'</td>'+
      '<td>'+esc(shortContractLabel(x.k?.number)||'-')+'</td>'+
      '<td>'+prodDateId(x.s.closed_on)+'</td>'+
      '<td>Rp '+prodFmt(x.s.system_amount,0)+'</td>'+
      '<td><strong>'+(x.real?'SUDAH INPUT':'MENUNGGU')+'</strong></td>'+
      '<td>'+(x.real?'Rp '+prodFmt(x.diff,0):'-')+'</td>'+
      '<td><button type="button" data-open-rhpp-real="'+esc(x.s.contract_assignment_id)+'">'+(st.selected===x.s.contract_assignment_id?'Tutup':'Buka')+'</button></td>'+
    '</tr>').join('')+
    '</tbody></table></div>'+
    (!cards.length?'<p class="muted">Tidak ada data sesuai filter.</p>':'')+
    '</section>';

  const selected=st.shown?systems.find(x=>x.contract_assignment_id===st.selected):null;
  if(selected){
    const a=assignments.find(x=>x.id===selected.contract_assignment_id);
    const b=barns.find(x=>x.id===selected.barn_id);
    const k=contractsRows.find(x=>x.id===a?.master_contract_id);
    const real=reals.find(x=>x.contract_assignment_id===selected.contract_assignment_id);
    const diff=real?prodNum(real.amount)-prodNum(selected.system_amount):null;
    const diffLabel=diff===null?'MENUNGGU':diff===0?'SESUAI':diff>0?'REAL LEBIH BESAR':'REAL LEBIH KECIL';

    html+='<section class="panel" id="rhppRealDetail">'+
      '<div class="rhpp-section-head"><div><h3>'+esc(assignmentIdentity(assignments,barns,contractsRows,a))+'</h3>'+
      '<p class="muted">RHPP Sistem Close '+prodDateId(selected.closed_on)+'</p></div><div class="report-actions"><button type="button" id="rhppRealPrint">Cetak / PDF</button></div></div>'+
      '<div class="tablewrap"><table><tbody>'+
        '<tr><td>RHPP Sistem Final</td><td><strong>Rp '+prodFmt(selected.system_amount,0)+'</strong></td></tr>'+
        '<tr><td>RHPP Real Diterima</td><td><strong>'+(real?'Rp '+prodFmt(real.amount,0):'MENUNGGU INPUT KEUANGAN')+'</strong></td></tr>'+
        '<tr><td>Selisih Real − Sistem</td><td><strong>'+(real?'Rp '+prodFmt(diff,0):'-')+'</strong></td></tr>'+
        '<tr><td>Status Selisih</td><td><strong>'+diffLabel+'</strong></td></tr>'+
      '</tbody></table></div>'+
      (real?
        '<p class="muted">RHPP Real tersimpan '+prodDateId(real.received_on)+'. Data tidak dapat diedit dari layar ini.</p>':
        canInput?
          '<form class="form-vertical" data-rhpp-real-form="'+esc(selected.contract_assignment_id)+'">'+
            '<label>Nominal RHPP Real Diterima<input name="amount" type="text" inputmode="decimal" data-number="1" required placeholder="Rp"></label>'+
            '<button type="submit">Simpan RHPP Real</button>'+
          '</form>':
          '<p class="muted">Menunggu Keuangan menginput RHPP Real.</p>'
      )+
    '</section>';
  }

  layout(html);bindNumberInputs();if(err)msg(err.message);const rhppRealPrint=document.getElementById('rhppRealPrint');if(rhppRealPrint)rhppRealPrint.onclick=()=>printFinanceDocument('rhppRealDetail','RHPP Real');

  const filter=document.getElementById('rhppRealFilter');
  const rhppBarn=document.getElementById('rhppRealBarn');
  if(rhppBarn)rhppBarn.onchange=async()=>{st.barn=rhppBarn.value||'';st.assignment='';st.selected='';st.shown=false;await financeRhppRealPage();};
  if(filter)filter.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(filter);
    st.barn=String(fd.get('barn')||'');
    st.assignment=String(fd.get('assignment')||'');
    st.status=String(fd.get('status')||'');
    if(!st.barn)return msg('Pilih kandang.');
    if(!st.assignment)return msg('Pilih siklus.');
    st.selected='';
    st.shown=true;
    await financeRhppRealPage();
  };

  root.querySelectorAll('[data-open-rhpp-real]').forEach(btn=>btn.onclick=async()=>{
    const id=btn.dataset.openRhppReal;
    st.selected=st.selected===id?'':id;
    await financeRhppRealPage();
  });

  if(canInput)root.querySelectorAll('[data-rhpp-real-form]').forEach(form=>form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form);
    const amount=normalizeInputID(fd.get('amount'));
    if(amount===null||amount<0)return msg('Nominal RHPP Real tidak valid.');
    if(!confirm('Simpan RHPP Real sebesar Rp '+prodFmt(amount,0)+'? Setelah tersimpan, nominal ini tidak diedit dari layar Keuangan.'))return;
    const {error}=await db.rpc('finance_save_rhpp_real_atomic',{
      p_contract_assignment_id:form.dataset.rhppRealForm,
      p_amount:amount,
      p_received_on:today,
      p_reference:null,
      p_notes:null
    });
    if(error)return msg(error.message);
    st.selected='';
    await financeRhppRealPage();
    msg('RHPP Real berhasil disimpan. Selisih Sistem vs Real sudah dihitung.',true);
  });
}

async function ownerProfitLossPage(){
  const [sr,rr,br,ar,cr,bopr]=await Promise.all([
    db.from('rhpp_system_final').select('*').order('created_at',{ascending:false}),
    db.from('rhpp_real').select('*').order('created_at',{ascending:false}),
    db.from('barns').select('id,code,name'),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active'),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('bop').select('contract_assignment_id,amount')
  ]);
  const systems=sr.data||[],reals=rr.data||[],barns=br.data||[],assignments=ar.data||[],contractsRows=cr.data||[],bops=bopr.data||[];
  const err=[sr,rr,br,ar,cr,bopr].find(x=>x.error)?.error;

  let html='<section class="panel"><h3>Owner · Laba/Rugi per Kandang</h3><p class="muted">Dasar Owner: RHPP Real yang diterima Keuangan dikurangi BOP kandang. RHPP Sistem tetap ditampilkan sebagai pembanding dan tidak diubah.</p></section>';
  if(!systems.length){
    html+='<section class="panel"><p>Belum ada RHPP Sistem Final dari Administrator.</p></section>';
    layout(html);if(err)msg(err.message);return;
  }

  systems.forEach(s=>{
    const a=assignments.find(x=>x.id===s.contract_assignment_id);
    const b=barns.find(x=>x.id===s.barn_id);
    const k=contractsRows.find(x=>x.id===a?.master_contract_id);
    const real=reals.find(x=>x.contract_assignment_id===s.contract_assignment_id);
    const bop=bops.filter(x=>x.contract_assignment_id===s.contract_assignment_id).reduce((n,x)=>n+prodNum(x.amount),0);
    const variance=real?prodNum(real.amount)-prodNum(s.system_amount):null;
    const profit=real?prodNum(real.amount)-bop:null;
    const resultLabel=profit===null?'MENUNGGU RHPP REAL':profit>0?'LABA':profit<0?'RUGI':'IMPAS';

    html+='<section class="panel">'+
      '<h3>'+esc(assignmentIdentity(assignments,barns,contractsRows,a))+'</h3>'+
      '<p class="muted">Close '+prodDateId(s.closed_on)+'</p>'+
      '<div class="tablewrap"><table><tbody>'+
        '<tr><td>RHPP Sistem Final</td><td><strong>Rp '+prodFmt(s.system_amount,0)+'</strong></td></tr>'+
        '<tr><td>RHPP Real</td><td><strong>'+(real?'Rp '+prodFmt(real.amount,0):'MENUNGGU KEUANGAN')+'</strong></td></tr>'+
        '<tr><td>Selisih Real − Sistem</td><td><strong>'+(real?'Rp '+prodFmt(variance,0):'-')+'</strong></td></tr>'+
        '<tr><td>BOP Kandang</td><td><strong>Rp '+prodFmt(bop,0)+'</strong></td></tr>'+
        '<tr><td>RHPP Real − BOP</td><td><strong>'+(real?'Rp '+prodFmt(profit,0):'-')+'</strong></td></tr>'+
        '<tr><td>Hasil</td><td><strong>'+resultLabel+'</strong></td></tr>'+
      '</tbody></table></div>'+
      (real?'<p class="muted">RHPP Real diterima '+prodDateId(real.received_on)+'.</p>':'<p class="muted">Perhitungan laba/rugi aktif setelah Keuangan menyimpan RHPP Real.</p>')+
    '</section>';
  });

  layout(html);if(err)msg(err.message);
}

async function financeRhppPage(){
  window.__financeRhppState=window.__financeRhppState||{assignment:''};
  const [pr,rr,hr,sr,sir,rtr,rir,ir,esr,esir,errh,erir,tir,cir,cpr]=await Promise.all([
    db.rpc('finance_rhpp_summary_v5'),
    db.from('rhpp_system_final').select('*').order('created_at',{ascending:false}),
    db.from('marketing_contract_harvests').select('*').order('harvested_on',{ascending:true}).order('created_at',{ascending:true}),
    db.from('logistics_shipments').select('id,contract_assignment_id,shipment_date'),
    db.from('logistics_shipment_items').select('shipment_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('logistics_returns').select('id,contract_assignment_id,return_date'),
    db.from('logistics_return_items').select('return_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('items').select('id,name,category,feed_phase,unit,kg_per_unit'),
    db.from('logistics_external_shipments').select('id,contract_assignment_id,shipment_date'),
    db.from('logistics_external_shipment_items').select('external_shipment_id,item_id,quantity,quantity_kg,purchase_unit_price'),
    db.from('logistics_external_returns').select('id,contract_assignment_id,return_date'),
    db.from('logistics_external_return_items').select('external_return_id,item_id,quantity,quantity_kg,purchase_unit_price'),
    db.from('logistics_external_return_transfers').select('target_contract_assignment_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('chick_ins').select('contract_assignment_id,arrived_on,received,doa'),
    db.from('company_profile').select('company_name,legal_name,logo_url,address,phone,email,website').eq('id',true).maybeSingle()
  ]);
  const rows=pr.data||[],finals=rr.data||[],harvests=hr.data||[],ships=sr.data||[],shipItems=sir.data||[],returns=rtr.data||[],returnItems=rir.data||[],items=ir.data||[];
  const extShips=esr.data||[],extShipItems=esir.data||[],extReturns=errh.data||[],extReturnItems=erir.data||[],transfersIn=tir.data||[],chickIns=cir.data||[],company=cpr.data||{};
  const err=[pr,rr,hr,sr,sir,rtr,rir,ir,esr,esir,errh,erir,tir,cir,cpr].find(x=>x.error)?.error;

  let html='<div class="rhpp-page" id="rhppExportArea"><section class="panel rhpp-panel rhpp-intro"><div class="rhpp-section-head"><div><h3>RHPP Otomatis</h3>'+
    '<p class="muted">RHPP dihitung langsung dari Chick-In, Logistik, Retur, Panen Marketing, Master Performa, dan Bonus Kontrak. BOP kandang tidak masuk RHPP.</p></div></div></section>';

  if(!rows.length){
    html+='<section class="panel rhpp-panel"><p>Belum ada data yang dapat dihitung.</p></section></div>';
    layout(html);
    if(err)msg(err.message);
    return;
  }

  const activeRows=rows.filter(x=>!!x.active);
  let selectedAssignment=window.__financeRhppState.assignment||'';
  if(selectedAssignment&&!activeRows.some(x=>x.contract_assignment_id===selectedAssignment)){
    selectedAssignment='';
    window.__financeRhppState.assignment='';
  }
  html+='<section class="panel rhpp-panel"><h3>Pilih Kandang</h3>'+
    '<p class="muted">Pilih kandang terlebih dahulu untuk membuka rincian RHPP. Satu kandang ditampilkan dalam satu waktu.</p>'+
    '<label>Kandang / Periode<select id="rhppBarnSelect"><option value="">Pilih kandang</option>'+
      activeRows.map(x=>'<option value="'+esc(x.contract_assignment_id)+'" '+(selectedAssignment===x.contract_assignment_id?'selected':'')+'>'+
        esc((x.barn_code||'')+' · '+(x.barn_name||'')+' · '+(x.contract_number||'')+' · Aktif')+
      '</option>').join('')+
    '</select></label></section>';

  if(!activeRows.length){
    html+='<section class="panel rhpp-panel"><p class="muted">Tidak ada periode kandang aktif. Periode yang sudah Closed disembunyikan dari daftar.</p></section></div>';
    layout(html);
    if(err)msg(err.message);
    return;
  }

  if(!selectedAssignment||!activeRows.some(x=>x.contract_assignment_id===selectedAssignment)){
    html+='<section class="panel rhpp-panel"><p class="muted">Belum ada kandang dipilih. Rincian RHPP tidak ditampilkan.</p></section></div>';
    layout(html);
    if(err)msg(err.message);
    const sel=document.getElementById('rhppBarnSelect');
    if(sel)sel.onchange=async()=>{
      window.__financeRhppState.assignment=sel.value||'';
      await financeRhppPage();
    };
    return;
  }

  const selectedRows=activeRows.filter(x=>x.contract_assignment_id===selectedAssignment);
  selectedRows.forEach(x=>{
    const fin=finals.find(r=>r.contract_assignment_id===x.contract_assignment_id);
    const variance=Math.abs(prodNum(x.depletion_variance_birds));
    const ready=!fin&&!!x.active&&prodNum(x.chick_in_birds)>0&&prodNum(x.total_harvest_birds)>0&&prodNum(x.total_harvest_kg)>0&&prodNum(x.net_feed_kg)>0&&prodNum(x.sapronak_cost)>0;
    const status=fin?'CLOSED · RHPP SISTEM FINAL':ready?'SIAP DICEK & CLOSE':'BELUM SIAP';
    const warning=variance>=0.5?'Pembanding populasi: selisih '+prodFmt(x.depletion_variance_birds,0)+' ekor. Tidak memblokir RHPP Final.':'';
    const hs=harvests.filter(h=>h.contract_assignment_id===x.contract_assignment_id);

    const shipIds=new Set(ships.filter(s=>s.contract_assignment_id===x.contract_assignment_id).map(s=>s.id));
    const retIds=new Set(returns.filter(r=>r.contract_assignment_id===x.contract_assignment_id).map(r=>r.id));
    const feedMap=new Map();
    shipItems.filter(v=>shipIds.has(v.shipment_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='MAIN:'+v.item_id;
      const o=feedMap.get(key)||{name:'Utama · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0};
      o.inQty+=prodNum(v.quantity);o.inKg+=prodNum(v.quantity_kg);feedMap.set(key,o);
    });
    returnItems.filter(v=>retIds.has(v.return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='MAIN:'+v.item_id;
      const o=feedMap.get(key)||{name:'Utama · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0};
      o.retQty+=prodNum(v.quantity);o.retKg+=prodNum(v.quantity_kg);feedMap.set(key,o);
    });

    const extShipIds=new Set(extShips.filter(s=>s.contract_assignment_id===x.contract_assignment_id).map(s=>s.id));
    const extRetIds=new Set(extReturns.filter(r=>r.contract_assignment_id===x.contract_assignment_id).map(r=>r.id));
    extShipItems.filter(v=>extShipIds.has(v.external_shipment_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='EXT:'+v.item_id;
      const o=feedMap.get(key)||{name:'Tambah Sapronak · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0};
      o.inQty+=prodNum(v.quantity);o.inKg+=prodNum(v.quantity_kg);feedMap.set(key,o);
    });
    extReturnItems.filter(v=>extRetIds.has(v.external_return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='EXT:'+v.item_id;
      const o=feedMap.get(key)||{name:'Tambah Sapronak · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0};
      o.retQty+=prodNum(v.quantity);o.retKg+=prodNum(v.quantity_kg);feedMap.set(key,o);
    });
    transfersIn.filter(v=>v.target_contract_assignment_id===x.contract_assignment_id).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);
      if(it?.category!=='PAKAN')return;
      const key='TRANSFER:'+v.item_id;
      const o=feedMap.get(key)||{name:'Alih Masuk · '+(it?.name||'-'),inQty:0,inKg:0,retQty:0,retKg:0};
      o.inQty+=prodNum(v.quantity);o.inKg+=prodNum(v.quantity_kg);feedMap.set(key,o);
    });
    const feedRows=[...feedMap.values()];

    html+='<section class="panel rhpp-panel rhpp-head"><h3>'+esc((x.barn_code||'')+' · '+(x.barn_name||''))+'</h3>'+
      '<p class="muted">'+esc(x.contract_number||'')+' · Status: <strong>'+status+'</strong></p>'+
      (warning?'<p class="error">'+esc(warning)+'</p>':'')+
      '</section>';

    html+='<section class="panel rhpp-panel rhpp-wide rhpp-harvest"><div class="rhpp-section-head"><div><h3>Rincian Panen</h3><p class="muted">Data panen Marketing yang menjadi sumber nilai produksi RHPP.</p></div><span class="rhpp-count">'+hs.length+' transaksi</span></div>'+
      '<div class="tablewrap rhpp-harvest-wrap"><table class="rhpp-harvest-table"><thead><tr>'+
      '<th class="rhpp-sticky-col">Tanggal</th><th>Pembeli / RPA</th><th>No. Kendaraan</th><th class="num">Ekor</th><th class="num">Berat (Kg)</th><th class="num">BW</th><th class="num">Harga/Kg</th><th class="num rhpp-money-col">Nilai Produksi</th>'+
      '</tr></thead><tbody>'+
      hs.map(h=>'<tr><td class="rhpp-sticky-col">'+prodDateId(h.harvested_on)+'</td><td>'+esc(h.buyer_name||'-')+'</td><td>'+esc(h.vehicle_number||'-')+'</td><td class="num">'+prodFmt(h.birds,0)+'</td><td class="num">'+prodFmt(h.net_weight_kg,2)+'</td><td class="num">'+prodFmt(h.avg_weight_kg,3)+'</td><td class="num">Rp '+prodFmt(h.price_per_kg,0)+'</td><td class="num rhpp-money-col">Rp '+prodFmt(h.total_amount,0)+'</td></tr>').join('')+
      '<tr class="rhpp-total-row"><th colspan="3">TOTAL PANEN</th><th class="num">'+prodFmt(x.total_harvest_birds,0)+'</th><th class="num">'+prodFmt(x.total_harvest_kg,2)+'</th><th class="num">'+prodFmt(x.avg_bw_kg,3)+'</th><th></th><th class="num">Rp '+prodFmt(x.harvest_value,0)+'</th></tr>'+
      '</tbody></table></div>'+
      '<div class="rhpp-summary-cards">'+
        '<div class="rhpp-summary-card"><span>Total Ekor</span><strong>'+prodFmt(x.total_harvest_birds,0)+'</strong></div>'+
        '<div class="rhpp-summary-card"><span>Total Berat</span><strong>'+prodFmt(x.total_harvest_kg,2)+' Kg</strong></div>'+
        '<div class="rhpp-summary-card"><span>BW Rata-rata</span><strong>'+prodFmt(x.avg_bw_kg,3)+' Kg</strong></div>'+
        '<div class="rhpp-summary-card rhpp-summary-value"><span>Nilai Produksi</span><strong>Rp '+prodFmt(x.harvest_value,0)+'</strong></div>'+
      '</div></section>'+
      '<section class="panel rhpp-panel rhpp-wide rhpp-extra-cost"><div class="rhpp-section-head"><div><h3>Biaya Tambahan Marketing</h3><p class="muted">Dipisahkan dari rincian panen agar sumber pendapatan dan biaya tidak tercampur.</p></div></div>'+
      '<div class="rhpp-cost-line"><span>Tambah Daging Marketing</span><strong>Rp '+prodFmt(x.external_meat_cost,0)+'</strong></div>'+
      '</section>';

    html+='<section class="panel rhpp-panel rhpp-wide rhpp-feed-panel"><h3>Pemakaian Pakan & Retur</h3><div class="tablewrap"><table class="rhpp-feed-table"><thead><tr>'+
      '<th>Jenis</th><th class="num">Masuk</th><th class="num">Retur</th><th class="num">Bersih</th><th class="num">Bersih Kg</th>'+
      '</tr></thead><tbody>'+
      feedRows.map(v=>{const parts=String(v.name||'').split(' · '),kind=parts[0]||'',item=parts.slice(1).join(' · ')||kind;return '<tr><td class="rhpp-feed-name"><span class="rhpp-feed-kind">'+esc(kind)+'</span><strong>'+esc(item)+'</strong></td><td class="num">'+prodFmt(v.inQty,2)+'</td><td class="num">'+prodFmt(v.retQty,2)+'</td><td class="num">'+prodFmt(v.inQty-v.retQty,2)+'</td><td class="num">'+prodFmt(v.inKg-v.retKg,2)+'</td></tr>';}).join('')+
      '<tr class="rhpp-total-row"><th>TOTAL BERSIH</th><th></th><th></th><th></th><th class="num">'+prodFmt(x.net_feed_kg,2)+'</th></tr>'+
      '</tbody></table></div></section>';

    html+='<div class="rhpp-grid">'+
      '<section class="panel rhpp-panel"><h3>Ringkasan Produksi</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>Nama Kandang / Peternak</td><td>'+esc(x.barn_name||'-')+'</td></tr>'+
        '<tr><td>Populasi Chick-In</td><td>'+prodFmt(x.chick_in_birds,0)+'</td></tr>'+
        '<tr><td>Total Panen (Ekor)</td><td>'+prodFmt(x.total_harvest_birds,0)+'</td></tr>'+
        '<tr><td>Total Panen (Kg)</td><td>'+prodFmt(x.total_harvest_kg,2)+'</td></tr>'+
        '<tr><td>BW Rataan</td><td>'+prodFmt(x.avg_bw_kg,3)+'</td></tr>'+
        '<tr><td>Umur Panen</td><td>'+prodFmt(x.weighted_age,2)+'</td></tr>'+
      '</tbody></table></div></section>'+

      '<section class="panel rhpp-panel"><h3>Kinerja Produksi</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>Mortalitas</td><td>'+prodFmt(x.mortality_pct,2)+'%</td></tr>'+
        '<tr><td>Bobot Badan</td><td>'+prodFmt(x.avg_bw_kg,3)+'</td></tr>'+
        '<tr><td>Pakan Utama Bersih</td><td>'+prodFmt(x.main_feed_kg,2)+'</td></tr>'+
        '<tr><td>Pakan Tambahan Bersih</td><td>'+prodFmt(x.external_feed_kg,2)+'</td></tr>'+
        '<tr><td>Total Pakan</td><td>'+prodFmt(x.net_feed_kg,2)+'</td></tr>'+
        '<tr><td>Umur Panen</td><td>'+prodFmt(x.weighted_age,2)+'</td></tr>'+
        '<tr><td>FCR</td><td>'+prodFmt(x.fcr_actual,3)+'</td></tr>'+
        '<tr><td>FCR Standar</td><td>'+prodFmt(x.fcr_standard,3)+'</td></tr>'+
        '<tr><td>DIFF FCR</td><td>'+prodFmt(x.diff_fcr,3)+'</td></tr>'+
        '<tr><td>Indeks Prestasi</td><td>'+prodFmt(x.ip,2)+'</td></tr>'+
      '</tbody></table></div></section>'+

      '<section class="panel rhpp-panel"><h3>Perhitungan RHPP</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>Deplesi PPL</td><td>'+prodFmt(x.recorded_depletion_birds,0)+'</td></tr>'+
        '<tr><td>Chick-In − Panen</td><td>'+prodFmt(x.implied_depletion_birds,0)+'</td></tr>'+
        '<tr><td>Sisa Belum Terjelaskan</td><td>'+prodFmt(x.depletion_variance_birds,0)+'</td></tr>'+
        '<tr><td>Pembanding Populasi</td><td>'+(x.population_balanced?'SEIMBANG':'SELISIH '+prodFmt(x.depletion_variance_birds,0)+' EKOR')+'</td></tr>'+
        '<tr><td>Nilai Panen</td><td>Rp '+prodFmt(x.harvest_value,0)+'</td></tr>'+
        '<tr><td>DOC Utama</td><td>Rp '+prodFmt(x.main_doc_cost,0)+'</td></tr>'+
        '<tr><td>Pakan Utama</td><td>Rp '+prodFmt(x.main_feed_cost,0)+'</td></tr>'+
        '<tr><td>OVK Utama</td><td>Rp '+prodFmt(x.main_ovk_cost,0)+'</td></tr>'+
        '<tr><td>Retur RHPP</td><td>- Rp '+prodFmt(x.main_return_cost,0)+'</td></tr>'+
        '<tr><td>Tambah Sapronak Netto</td><td>Rp '+prodFmt(x.external_sapronak_cost,0)+'</td></tr>'+
        '<tr><td>Total Sapronak</td><td>Rp '+prodFmt(x.sapronak_cost,0)+'</td></tr>'+

        '<tr><td><strong>Total Biaya RHPP</strong></td><td><strong>Rp '+prodFmt(x.total_rhpp_cost,0)+'</strong></td></tr>'+
        '<tr><td>Laba Dasar</td><td>Rp '+prodFmt(x.base_profit,0)+'</td></tr>'+
      '</tbody></table></div></section>'+

      '<section class="panel rhpp-panel"><h3>Nilai RHPP</h3><div class="tablewrap"><table><tbody>'+
        '<tr><td>Bonus IP</td><td>Rp '+prodFmt(x.bonus_ip,0)+' ('+prodFmt(x.bonus_ip_rate,0)+'/kg)</td></tr>'+
        '<tr><td>Bonus FC</td><td>Rp '+prodFmt(x.bonus_fc,0)+' ('+prodFmt(x.bonus_fc_rate,0)+'/kg)</td></tr>'+
        '<tr><td>Bonus Deplesi</td><td>Rp '+prodFmt(x.bonus_mortality,0)+' ('+prodFmt(x.bonus_mortality_rate,0)+'/kg)</td></tr>'+
        '<tr><td><strong>Laba Peternak</strong></td><td><strong>Rp '+prodFmt(x.farmer_profit,0)+'</strong></td></tr>'+
        '<tr><td>Laba / Chick-In</td><td>Rp '+prodFmt(x.profit_per_chick_in,0)+'</td></tr>'+
        '<tr><td>Laba / Ekor Panen</td><td>Rp '+prodFmt(x.profit_per_harvested_bird,0)+'</td></tr>'+
      '</tbody></table></div>'+
      '<p><strong>Status: '+status+'</strong></p>'+
      (fin?'<p class="muted">Close Produksi '+prodDateId(fin.closed_on)+' · RHPP Sistem Rp '+prodFmt(fin.system_amount,0)+'</p>':ready?'<button type="button" class="btn-danger-soft" data-close-rhpp="'+esc(x.contract_assignment_id)+'">Deal & Close Produksi</button>':'<p class="muted">Lengkapi data operasional sebelum Close</p>')+
      '</section>'+
    '</div>';
  });

  html+='<section class="panel rhpp-panel rhpp-control"><h3>Kontrol RHPP Produksi</h3><p class="muted">Administrator periksa RHPP Sistem terlebih dahulu. Jika sudah deal, klik Close Produksi. Setelah Close, seluruh transaksi operasional periode terkunci. RHPP Real tetap menjadi urusan Keuangan.</p></section></div>';

  layout(html);
  if(err)msg(err.message);
  const rhppBarnSelect=document.getElementById('rhppBarnSelect');
  if(rhppBarnSelect)rhppBarnSelect.onchange=async()=>{
    window.__financeRhppState.assignment=rhppBarnSelect.value||'';
    await financeRhppPage();
  };

  const rhppExport=document.getElementById('rhppExportArea');
  const rhppDocHtml=(pdf=false)=>{
    const x=activeRows.find(v=>v.contract_assignment_id===selectedAssignment);
    if(!x)return '<!doctype html><html><body>Data RHPP tidak ditemukan.</body></html>';
    const hs=harvests.filter(h=>h.contract_assignment_id===selectedAssignment);
    const ci=chickIns.find(v=>v.contract_assignment_id===selectedAssignment);
    const shipIds=new Set(ships.filter(s=>s.contract_assignment_id===selectedAssignment).map(s=>s.id));
    const retIds=new Set(returns.filter(r=>r.contract_assignment_id===selectedAssignment).map(r=>r.id));
    const extShipIds=new Set(extShips.filter(s=>s.contract_assignment_id===selectedAssignment).map(s=>s.id));
    const extRetIds=new Set(extReturns.filter(r=>r.contract_assignment_id===selectedAssignment).map(r=>r.id));
    const feed=new Map();
    const feedRow=(itemId)=>{
      const it=items.find(i=>i.id===itemId);
      if(!it||it.category!=='PAKAN')return null;
      const phase=String(it.feed_phase||it.name||'').toLowerCase();
      let group='Suplayer Lain';
      if(phase.includes('free')||phase.includes('pre'))group='Free Starter';
      else if(phase.includes('finish')||phase.includes('finis'))group='Finisher';
      else if(phase.includes('starter'))group='Starter';
      const key=group;
      if(!feed.has(key))feed.set(key,{name:group,inQty:0,inKg:0,retQty:0,retKg:0,priceKg:0});
      return {it,row:feed.get(key)};
    };
    shipItems.filter(v=>shipIds.has(v.shipment_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.inQty+=prodNum(v.quantity);z.row.inKg+=prodNum(v.quantity_kg);
      const kgPer=prodNum(z.it.kg_per_unit);const p=kgPer>0?prodNum(v.unit_price)/kgPer:0;
      if(p>0)z.row.priceKg=p;
    });
    returnItems.filter(v=>retIds.has(v.return_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.retQty+=prodNum(v.quantity);z.row.retKg+=prodNum(v.quantity_kg);
      const kgPer=prodNum(z.it.kg_per_unit);const p=kgPer>0?prodNum(v.unit_price)/kgPer:0;
      if(!z.row.priceKg&&p>0)z.row.priceKg=p;
    });
    extShipItems.filter(v=>extShipIds.has(v.external_shipment_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.inQty+=prodNum(v.quantity);z.row.inKg+=prodNum(v.quantity_kg);
    });
    extReturnItems.filter(v=>extRetIds.has(v.external_return_id)).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.retQty+=prodNum(v.quantity);z.row.retKg+=prodNum(v.quantity_kg);
    });
    transfersIn.filter(v=>v.target_contract_assignment_id===selectedAssignment).forEach(v=>{
      const z=feedRow(v.item_id);if(!z)return;
      z.row.inQty+=prodNum(v.quantity);z.row.inKg+=prodNum(v.quantity_kg);
      const kgPer=prodNum(z.it.kg_per_unit);const p=kgPer>0?prodNum(v.unit_price)/kgPer:0;
      if(!z.row.priceKg&&p>0)z.row.priceKg=p;
    });
    const feedOrder=['Free Starter','Starter','Finisher','Suplayer Lain'];
    const feedRows=feedOrder.map(n=>feed.get(n)||{name:n,inQty:0,inKg:0,retQty:0,retKg:0,priceKg:0});
    const cleanZak=feedRows.reduce((s,v)=>s+v.inQty-v.retQty,0);
    const cleanKg=feedRows.reduce((s,v)=>s+v.inKg-v.retKg,0);
    const returnDetail=[];
    returnItems.filter(v=>retIds.has(v.return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);if(it?.category!=='PAKAN')return;
      returnDetail.push({name:'Retur '+(it.feed_phase||it.name||'Pakan'),qty:prodNum(v.quantity),kg:prodNum(v.quantity_kg),value:prodNum(v.quantity)*prodNum(v.unit_price)});
    });
    extReturnItems.filter(v=>extRetIds.has(v.external_return_id)).forEach(v=>{
      const it=items.find(i=>i.id===v.item_id);if(it?.category!=='PAKAN')return;
      returnDetail.push({name:'Retur '+(it.feed_phase||it.name||'Pakan'),qty:prodNum(v.quantity),kg:prodNum(v.quantity_kg),value:prodNum(v.quantity)*prodNum(v.purchase_unit_price)});
    });
    const money=v=>prodFmt(v,0);
    const num2=v=>prodFmt(v,2);
    const val=(label,value)=>'<div class="kv"><span>'+esc(label)+'</span><b>:</b><strong>'+value+'</strong></div>';
    const chickIn=prodNum(x.chick_in_birds||((ci?.received||0)-(ci?.doa||0)));
    const feedPerBird=chickIn>0?prodNum(x.net_feed_kg)*1000/chickIn:0;
    const docPrice=chickIn>0?prodNum(x.main_doc_cost)/chickIn:0;
    const grossSapronak=prodNum(x.sapronak_cost)+prodNum(x.main_return_cost);
    const title=pdf?'RHPP_Sistem_PDF':'RHPP Sistem';
    const harvestRows=hs.map(h=>'<tr><td>'+prodDateId(h.harvested_on)+'</td><td>'+esc(h.buyer_name||'-')+'</td><td>'+esc(h.vehicle_number||'-')+'</td><td class="n">'+prodFmt(h.birds,0)+'</td><td class="n">'+num2(h.net_weight_kg)+'</td><td class="n">'+num2(h.avg_weight_kg)+'</td><td class="n">'+money(h.price_per_kg)+'</td><td class="n">'+money(h.total_amount)+'</td></tr>').join('');
    const feedHtml=feedRows.map(v=>{
      const netQty=v.inQty-v.retQty,netKg=v.inKg-v.retKg,price=v.priceKg||0;
      return '<tr><td>'+esc(v.name)+'</td><td class="n">'+num2(v.inQty)+'</td><td class="n">'+num2(v.retQty)+'</td><td class="n">'+num2(netQty)+'</td><td class="n">'+num2(netQty?netKg/netQty:0)+'</td><td class="n">'+num2(netKg)+'</td><td class="n">'+(price?money(price):'-')+'</td><td class="n">'+(price?money(netKg*price):'-')+'</td></tr>';
    }).join('');
    const retHtml=(returnDetail.length?returnDetail:[{name:'Retur Finisher',qty:0,kg:0,value:0}]).map(v=>'<tr><td>'+esc(v.name)+'</td><td class="n">'+num2(v.qty)+'</td><td class="n">'+num2(v.kg)+'</td><td class="n">'+money(v.value)+'</td></tr>').join('');
    const fin=finals.find(v=>v.contract_assignment_id===selectedAssignment);
    const closeLabel=fin?.closed_on?prodDateId(fin.closed_on):'BELUM CLOSE';
    const statusLabel=fin?'FINAL / CLOSED':'RHPP SISTEM / PROSES';
    const periodStart=ci?.arrived_on?prodDateId(ci.arrived_on):'-';
    const harvestDates=hs.map(v=>v.harvested_on).filter(Boolean).sort();
    const periodHarvest=harvestDates.length?(prodDateId(harvestDates[0])+' - '+prodDateId(harvestDates[harvestDates.length-1])):'-';
    const totalReturnKg=returnDetail.reduce((n,v)=>n+prodNum(v.kg),0);
    const avgFeedPrice=cleanKg>0?prodNum(x.main_feed_cost)/cleanKg:0;
    const ovkValue=prodNum(x.main_ovk_cost);
    const printStamp=new Intl.DateTimeFormat('id-ID',{timeZone:'Asia/Jakarta',dateStyle:'medium',timeStyle:'short'}).format(new Date())+' WIB';
    const companyName=company.company_name||company.legal_name||'Bagjasindo Mandiri Sindangkasih';
    const companyContact=[company.address,company.phone?('Tel/WA: '+company.phone):'',company.email||'',company.website||''].filter(Boolean).map(esc).join('<br>');
    const logo='<img class="logo" src="'+BMS_PRINT_LOGO+'" alt="Logo BMS">';
    const sig=(role)=>'<div class="sig"><strong>'+esc(role)+'</strong><div class="sig-space"></div><div class="sig-line"></div><span>Nama &amp; Tanda Tangan</span></div>';
    return '<!doctype html><html><head><meta charset="utf-8"><title>'+title+'</title>'+
      '<style>'+
      '@page{size:A4 landscape;margin:8mm}*{box-sizing:border-box}html,body{margin:0;padding:0;font-family:Arial,Helvetica,sans-serif;color:#10233f;font-size:9.2px;line-height:1.3;-webkit-print-color-adjust:exact!important;print-color-adjust:exact!important}body{background:#fff}.page{min-height:188mm;position:relative;padding-bottom:10mm}.page+.page{page-break-before:always}.head{display:grid;grid-template-columns:auto 1fr 250px;gap:12px;align-items:center;border-bottom:2px solid #153f73;padding:0 2px 8px;margin-bottom:9px}.logo{width:44px;height:44px;object-fit:contain}.logo-mark{width:44px;height:44px;border-radius:10px;background:#174d88!important;color:#fff!important;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:13px}.company h1{font-size:18px;margin:0;color:#123b6d}.company p{margin:2px 0 0;color:#53657a;font-size:9px}.contact{text-align:right;color:#33465f;font-size:8.6px}.doc-title{text-align:center;margin:9px 0 12px}.doc-title h2{font-size:22px;letter-spacing:.1px;margin:0;color:#102e57}.doc-title p{margin:3px 0 0;font-size:12px;color:#445a75}.section{margin:0 0 10px;border:1px solid #c7d8ea;border-radius:7px;overflow:hidden;break-inside:avoid}.section-title{background:#dcecf9!important;color:#123b6d!important;padding:6px 9px;font-size:11.5px;font-weight:800;letter-spacing:.1px}.section-body{padding:8px 9px}.meta{display:grid;grid-template-columns:1fr 1fr;gap:4px 34px}.meta-row{display:grid;grid-template-columns:125px 10px 1fr;min-height:18px;align-items:center}.meta-row strong{font-weight:700}.pill{display:inline-block;background:#d7f4e4!important;color:#145c3b!important;border-radius:5px;padding:3px 8px;font-weight:800}.metrics{display:grid;grid-template-columns:repeat(5,1fr);border:1px solid #d6e0eb;border-radius:6px;overflow:hidden}.metric{padding:7px 8px;min-height:55px;border-right:1px solid #d6e0eb;border-bottom:1px solid #d6e0eb}.metric:nth-child(5n){border-right:0}.metric:nth-child(n+6){border-bottom:0}.metric span{display:block;color:#53657a;font-size:8px}.metric strong{display:block;color:#123b6d;font-size:15px;margin-top:3px}.metric small{color:#53657a;font-size:7.5px}table{width:100%;border-collapse:collapse;table-layout:fixed}.tbl th{background:#e4f0fa!important;color:#193b64!important;border:1px solid #b7ccdf;padding:5px 4px;text-align:center;font-size:8px}.tbl td{border:1px solid #cfdae6;padding:4px 4px;color:#24384f}.tbl .n{text-align:right}.tbl .total td,.tbl .total th{background:#eaf3fb!important;font-weight:800;color:#133961}.calc td:first-child{width:72%}.calc .em td{background:#dcecf9!important;font-weight:800}.calc .final td{background:#124a84!important;color:#fff!important;font-weight:800;font-size:12px;padding:8px}.note{padding:8px 10px;color:#33465f}.signatures{display:grid;grid-template-columns:repeat(4,1fr);gap:0}.sig{text-align:center;padding:9px 10px;border-right:1px solid #d6e0eb}.sig:last-child{border-right:0}.sig-space{height:34px}.sig-line{border-top:1px dotted #8190a2;margin:0 12px 4px}.sig span{font-size:7.5px;color:#66768a}.footer{position:absolute;left:0;right:0;bottom:0;border-top:1px solid #dbe4ed;padding-top:4px;display:flex;justify-content:space-between;color:#65768a;font-size:7.5px}.page-no{font-weight:700}.top-ref{text-align:right;font-size:8px;color:#51647c;margin:-3px 0 7px}.money{font-variant-numeric:tabular-nums}'+
      '@media print{.page{min-height:188mm}.section,.metrics,.tbl,.signatures{-webkit-print-color-adjust:exact!important;print-color-adjust:exact!important}}'+
      '</style></head><body>'+
      '<section class="page">'+
        '<header class="head">'+logo+'<div class="company"><h1>'+esc(companyName)+'</h1><p>Integritas Kemitraan untuk Peternakan Lebih Baik</p></div><div class="contact">'+companyContact+'</div></header>'+
        '<div class="doc-title"><h2>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</h2><p>RHPP Sistem Final</p></div>'+
        '<div class="section"><div class="section-title">IDENTITAS PRODUKSI</div><div class="section-body meta">'+
          '<div class="meta-row"><strong>Kandang / Peternak</strong><b>:</b><span>'+esc(x.barn_name||'-')+'</span></div>'+
          '<div class="meta-row"><strong>Tanggal Close</strong><b>:</b><span>'+closeLabel+'</span></div>'+
          '<div class="meta-row"><strong>Nomor Kontrak</strong><b>:</b><span>'+esc(x.contract_number||'-')+'</span></div>'+
          '<div class="meta-row"><strong>Status</strong><b>:</b><span><span class="pill">'+statusLabel+'</span></span></div>'+
          '<div class="meta-row"><strong>Tanggal Chick-In</strong><b>:</b><span>'+periodStart+'</span></div>'+
          '<div class="meta-row"><strong>Periode Panen</strong><b>:</b><span>'+periodHarvest+'</span></div>'+
          '<div class="meta-row"><strong>Kode Kandang</strong><b>:</b><span>'+esc(x.barn_code||'-')+'</span></div>'+
          '<div class="meta-row"><strong>Sumber Data</strong><b>:</b><span>Chick-In · Logistik · Retur · Marketing · Master Performa</span></div>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">RINGKASAN PRODUKSI</div><div class="section-body">'+
          '<div class="metrics">'+
            '<div class="metric"><span>Populasi Awal</span><strong>'+prodFmt(chickIn,0)+'</strong><small>ekor</small></div>'+
            '<div class="metric"><span>Total Panen Ekor</span><strong>'+prodFmt(x.total_harvest_birds,0)+'</strong><small>ekor</small></div>'+
            '<div class="metric"><span>Total Berat Panen</span><strong>'+num2(x.total_harvest_kg)+'</strong><small>kg</small></div>'+
            '<div class="metric"><span>BW Rata-rata</span><strong>'+prodFmt(x.avg_bw_kg,3)+'</strong><small>kg/ekor</small></div>'+
            '<div class="metric"><span>Umur Panen</span><strong>'+prodFmt(x.weighted_age,2)+'</strong><small>hari</small></div>'+
            '<div class="metric"><span>Mortalitas</span><strong>'+prodFmt(x.mortality_pct,2)+'%</strong><small>'+prodFmt(x.recorded_depletion_birds,0)+' ekor</small></div>'+
            '<div class="metric"><span>Total Pakan</span><strong>'+num2(x.net_feed_kg)+'</strong><small>kg</small></div>'+
            '<div class="metric"><span>FCR Aktual</span><strong>'+prodFmt(x.fcr_actual,3)+'</strong><small>aktual</small></div>'+
            '<div class="metric"><span>FCR Standar</span><strong>'+prodFmt(x.fcr_standard,3)+'</strong><small>standar</small></div>'+
            '<div class="metric"><span>IP (Indeks Prestasi)</span><strong>'+prodFmt(x.ip,2)+'</strong><small>nilai IP</small></div>'+
          '</div>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">RINCIAN PANEN</div><div class="section-body">'+
          '<table class="tbl"><thead><tr><th style="width:5%">No.</th><th style="width:12%">Tanggal Panen</th><th style="width:16%">Pembeli / RPA</th><th style="width:13%">No. Kendaraan</th><th style="width:10%">Jumlah Ekor</th><th style="width:12%">Berat Total (Kg)</th><th style="width:10%">BW (Kg)</th><th style="width:10%">Harga/Kg</th><th style="width:12%">Nilai (Rp)</th></tr></thead><tbody>'+
          hs.map((h,idx)=>'<tr><td style="text-align:center">'+(idx+1)+'</td><td>'+prodDateId(h.harvested_on)+'</td><td>'+esc(h.buyer_name||'-')+'</td><td>'+esc(h.vehicle_number||'-')+'</td><td class="n">'+prodFmt(h.birds,0)+'</td><td class="n">'+num2(h.net_weight_kg)+'</td><td class="n">'+prodFmt(h.avg_weight_kg,3)+'</td><td class="n">'+money(h.price_per_kg)+'</td><td class="n money">'+money(h.total_amount)+'</td></tr>').join('')+
          '<tr class="total"><th colspan="4">TOTAL PANEN</th><td class="n">'+prodFmt(x.total_harvest_birds,0)+'</td><td class="n">'+num2(x.total_harvest_kg)+'</td><td class="n">'+prodFmt(x.avg_bw_kg,3)+'</td><td></td><td class="n money">'+money(x.harvest_value)+'</td></tr>'+
          '</tbody></table>'+
        '</div></div>'+
        '<footer class="footer"><div><strong>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</strong><br>'+esc(companyName)+'</div><div style="text-align:right"><span class="page-no">Halaman 1 dari 2</span><br>Dicetak pada: '+esc(printStamp)+'</div></footer>'+
      '</section>'+
      '<section class="page">'+
        '<header class="head">'+logo+'<div class="company"><h1>'+esc(companyName)+'</h1><p>Integritas Kemitraan untuk Peternakan Lebih Baik</p></div><div class="contact">'+companyContact+'</div></header>'+
        '<div class="top-ref">'+esc(x.barn_name||x.barn_code||'-')+' &nbsp; | &nbsp; '+esc(x.contract_number||'-')+' &nbsp; | &nbsp; '+statusLabel+'</div>'+
        '<div class="section"><div class="section-title">RINCIAN SAPRONAK</div><div class="section-body">'+
          '<table class="tbl"><thead><tr><th style="width:6%">No.</th><th>Jenis Sapronak</th><th style="width:14%">Qty</th><th style="width:12%">Satuan</th><th style="width:18%">Harga Satuan (Rp)</th><th style="width:20%">Nilai (Rp)</th></tr></thead><tbody>'+
            '<tr><td style="text-align:center">1</td><td>DOC (Day Old Chick)</td><td class="n">'+prodFmt(chickIn,0)+'</td><td>ekor</td><td class="n">'+money(docPrice)+'</td><td class="n money">'+money(x.main_doc_cost)+'</td></tr>'+
            '<tr><td style="text-align:center">2</td><td>Pakan Bersih</td><td class="n">'+num2(cleanKg)+'</td><td>kg</td><td class="n">'+money(avgFeedPrice)+'</td><td class="n money">'+money(x.main_feed_cost)+'</td></tr>'+
            '<tr><td style="text-align:center">3</td><td>OVK</td><td class="n">'+(ovkValue>0?'1':'0')+'</td><td>paket</td><td class="n">'+money(ovkValue)+'</td><td class="n money">'+money(ovkValue)+'</td></tr>'+
            '<tr><td style="text-align:center">4</td><td>Retur Sapronak</td><td class="n">'+num2(totalReturnKg)+'</td><td>kg</td><td class="n">-</td><td class="n money">- '+money(x.main_return_cost)+'</td></tr>'+
            '<tr><td style="text-align:center">5</td><td>Tambah Sapronak Netto</td><td class="n">-</td><td>-</td><td class="n">-</td><td class="n money">'+money(x.external_sapronak_cost)+'</td></tr>'+
            '<tr class="total"><th colspan="5">TOTAL SAPRONAK</th><td class="n money">'+money(x.sapronak_cost)+'</td></tr>'+
          '</tbody></table>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">PERHITUNGAN RHPP</div><div class="section-body">'+
          '<table class="tbl calc"><thead><tr><th style="width:7%">No.</th><th>Uraian</th><th style="width:28%">Nilai (Rp)</th></tr></thead><tbody>'+
            '<tr><td style="text-align:center">1</td><td>Nilai Produksi (Total Panen)</td><td class="n money">'+money(x.harvest_value)+'</td></tr>'+
            '<tr><td style="text-align:center">2</td><td>Total Sapronak</td><td class="n money">'+money(x.sapronak_cost)+'</td></tr>'+
            '<tr class="em"><td style="text-align:center">3</td><td>Laba Dasar</td><td class="n money">'+money(x.base_profit)+'</td></tr>'+
            '<tr><td style="text-align:center">4</td><td>Bonus IP · tarif '+money(x.bonus_ip_rate)+'/kg</td><td class="n money">'+money(x.bonus_ip)+'</td></tr>'+
            '<tr><td style="text-align:center">5</td><td>Bonus FC / FCR · tarif '+money(x.bonus_fc_rate)+'/kg</td><td class="n money">'+money(x.bonus_fc)+'</td></tr>'+
            '<tr><td style="text-align:center">6</td><td>Bonus Deplesi / Mortalitas · tarif '+money(x.bonus_mortality_rate)+'/kg</td><td class="n money">'+money(x.bonus_mortality)+'</td></tr>'+
            '<tr class="final"><td style="text-align:center">7</td><td>LABA PETERNAK / RHPP FINAL</td><td class="n money">'+money(x.farmer_profit)+'</td></tr>'+
          '</tbody></table>'+
        '</div></div>'+
        '<div class="section"><div class="section-title">CATATAN</div><div class="note">'+(fin?'Dokumen final berdasarkan snapshot saat Close Produksi. Nilai RHPP Sistem Final tidak dihitung ulang dari master terbaru.':'Dokumen masih dalam status proses dan belum menjadi snapshot final.')+'</div></div>'+
        '<div class="section"><div class="section-title">TANDA TANGAN</div><div class="signatures">'+sig('Peternak / ABK')+sig('PPL / Produksi')+sig('Administrator')+sig('Keuangan')+'</div></div>'+
        '<footer class="footer"><div><strong>REKAP HASIL PEMELIHARAAN PETERNAK (RHPP)</strong><br>'+esc(companyName)+'</div><div style="text-align:right"><span class="page-no">Halaman 2 dari 2</span><br>Dicetak pada: '+esc(printStamp)+'</div></footer>'+
      '</section>'+
      '</body></html>';
  };
  const rhppPrintOpen=(pdf=false)=>{
    const w=window.open('','_blank');if(!w)return msg('Popup cetak diblokir browser.');
    w.document.write(rhppDocHtml(pdf));w.document.close();
    setTimeout(()=>{w.focus();w.print();},500);
  };
  const printBtn=document.getElementById('rhppPrint');
  const pdfBtn=document.getElementById('rhppPdf');
  const excelBtn=document.getElementById('rhppExcel');
  if(printBtn)printBtn.onclick=()=>rhppPrintOpen(false);
  if(pdfBtn)pdfBtn.onclick=()=>rhppPrintOpen(true);
  if(excelBtn)excelBtn.onclick=()=>{
    const clone=rhppExport?.cloneNode(true);if(!clone)return;
    clone.querySelectorAll('button,.report-actions').forEach(x=>x.remove());
    const blob=new Blob(['\ufeff<html><head><meta charset="utf-8"></head><body><h2>RHPP Sistem</h2>'+clone.innerHTML+'</body></html>'],{type:'application/vnd.ms-excel;charset=utf-8'});
    const url=URL.createObjectURL(blob),a=document.createElement('a');
    a.href=url;a.download='RHPP_Sistem.xls';document.body.appendChild(a);a.click();a.remove();setTimeout(()=>URL.revokeObjectURL(url),1000);
  };

  root.querySelectorAll('[data-close-rhpp]').forEach(btn=>btn.onclick=async()=>{
    const x=rows.find(v=>v.contract_assignment_id===btn.dataset.closeRhpp);
    if(!x)return;
    if(!confirm('RHPP Sistem sudah diperiksa dan DEAL? Close Produksi akan mengunci seluruh transaksi operasional periode ini.'))return;
    const {error}=await db.rpc('admin_close_production_atomic',{p_contract_assignment_id:x.contract_assignment_id});
    if(error)return msg(error.message);
    await financeRhppPage();
    msg('Produksi berhasil di-Close. RHPP Sistem terkunci dan menunggu RHPP Real dari Keuangan.',true);
  });
}

async function employeeMasterPage(){
  const can=profile.role==='ADMIN';
  const {data,error}=await db.from('employees').select('*').order('code',{ascending:true});
  const rows=data||[];
  let html='<section class="panel"><h3>Master Karyawan</h3>';
  if(can){
    html+='<form id="employeeForm" class="form-vertical">'+
      '<input type="hidden" name="id">'+
      '<label>Nama<input name="name" required></label>'+
      '<label>Jenis<select name="kind"><option value="KARYAWAN">KARYAWAN</option><option value="ABK">ABK</option></select></label>'+
      '<label>Telepon<input name="phone"></label>'+
      '<label>Jabatan<input name="job_title"></label>'+
      '<label>Tanggal Masuk<input name="joined_on" type="date"></label>'+
      '<label>Catatan<textarea name="notes"></textarea></label>'+
      '<button type="submit" id="employeeSave">Simpan</button>'+
      '<button type="button" id="employeeCancelEdit" hidden>Batal Edit</button>'+
    '</form>';
  }
  html+='<div class="tablewrap"><table id="employeeMasterTable"><thead><tr><th>Kode</th><th>Nama</th><th>Jenis</th><th>Telepon</th><th>Jabatan</th><th>Tanggal Masuk</th><th>Status</th>'+(can?'<th>Aksi</th>':'')+'</tr></thead><tbody>'+
    rows.map(x=>'<tr><td>'+esc(x.code)+'</td><td>'+esc(x.name)+'</td><td>'+esc(x.kind)+'</td><td>'+esc(x.phone||'')+'</td><td>'+esc(x.job_title||'')+'</td><td>'+esc(x.joined_on||'')+'</td><td>'+(x.active?'Aktif':'Nonaktif')+'</td>'+(can?'<td><button type="button" data-edit-employee="'+esc(x.id)+'">Edit</button> <button type="button" data-toggle-employee="'+esc(x.id)+'">'+(x.active?'Nonaktifkan':'Aktifkan')+'</button></td>':'')+'</tr>').join('')+
    '</tbody></table></div>'+(!rows.length?'<p>Belum ada data.</p>':'')+'</section>';
  layout(html);
  attachListFilter({tableId:'employeeMasterTable',fields:[
    {label:'Kode',col:0,placeholder:'Kode'},
    {label:'Nama',col:1,placeholder:'Nama'},
    {label:'Jenis',col:2,type:'select',options:['KARYAWAN','ABK']},
    {label:'Telepon',col:3,placeholder:'Telepon'},
    {label:'Jabatan',col:4,placeholder:'Jabatan'},
    {label:'Tanggal Masuk',col:5,placeholder:'YYYY-MM-DD'},
    {label:'Status',col:6,type:'select',options:['Aktif','Nonaktif']}
  ]});
  if(error)msg(error.message);
  if(!can)return;
  const form=document.getElementById('employeeForm');
  const save=document.getElementById('employeeSave');
  const cancel=document.getElementById('employeeCancelEdit');
  const reset=()=>{
    form.reset();
    form.elements.id.value='';
    save.textContent='Simpan';
    cancel.hidden=true;
  };
  cancel.onclick=reset;
  root.querySelectorAll('[data-edit-employee]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.id===btn.dataset.editEmployee);if(!x)return;
    form.elements.id.value=x.id;
    form.elements.name.value=x.name||'';
    form.elements.kind.value=x.kind||'KARYAWAN';
    form.elements.phone.value=x.phone||'';
    form.elements.job_title.value=x.job_title||'';
    form.elements.joined_on.value=x.joined_on||'';
    form.elements.notes.value=x.notes||'';
    save.textContent='Simpan Perubahan';
    cancel.hidden=false;
    form.scrollIntoView({behavior:'smooth',block:'start'});
  });
  root.querySelectorAll('[data-toggle-employee]').forEach(btn=>btn.onclick=async()=>{
    const x=rows.find(v=>v.id===btn.dataset.toggleEmployee);if(!x)return;
    const {error}=await db.from('employees').update({active:!x.active}).eq('id',x.id);
    if(error)return msg(error.message);
    await employeeMasterPage();
    msg(x.active?'Karyawan/ABK dinonaktifkan.':'Karyawan/ABK diaktifkan kembali.',true);
  });
  form.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(form),id=fd.get('id');
    const o={
      name:fd.get('name'),
      kind:fd.get('kind'),
      phone:fd.get('phone')||null,
      job_title:fd.get('job_title')||null,
      joined_on:fd.get('joined_on')||null,
      notes:fd.get('notes')||null
    };
    const q=id?db.from('employees').update(o).eq('id',id):db.from('employees').insert(o);
    const {error}=await q;
    if(error)return msg(error.message);
    await employeeMasterPage();
    msg(id?'Data karyawan diperbarui.':'Data karyawan tersimpan.',true);
  };
}

async function users(){
  if(profile.role!=='ADMIN')return layout('<p>Akses hanya untuk Administrator.</p>');

  const {data,error}=await db.rpc('admin_list_bms_users');
  const rows=data||[];
  const rolesList=['ADMIN','LOGISTIK','PPL','MARKETING','KEUANGAN','OWNER'];

  let html='<section class="panel"><h3>Master Pengguna</h3>'+
    '<form id="createUserForm" class="form-vertical">'+
      '<label>Nama<input name="name" required></label>'+
      '<label>Email<input name="email" type="email" required></label>'+
      '<label>Role<select name="role">'+rolesList.map(r=>'<option value="'+r+'">'+r+'</option>').join('')+'</select></label>'+
      '<label>Password Awal<div class="password-wrap"><input id="newUserPassword1" name="password" type="password" autocomplete="new-password" required><button type="button" data-toggle-user-password="newUserPassword1">Lihat</button></div></label>'+
      '<label>Konfirmasi Password<div class="password-wrap"><input id="newUserPassword2" name="confirm_password" type="password" autocomplete="new-password" required><button type="button" data-toggle-user-password="newUserPassword2">Lihat</button></div></label>'+
      '<button type="submit">Buat Pengguna</button>'+
    '</form>'+
    '<p class="muted">Akun dibuat langsung oleh Administrator dan tidak memerlukan konfirmasi email.</p>'+
    '</section>';

  html+='<section class="panel"><h3>Daftar Pengguna</h3><div class="tablewrap"><table id="usersMasterTable"><thead><tr><th>Nama</th><th>Email</th><th>Role</th><th>Status</th><th>Aksi</th></tr></thead><tbody>'+
    rows.map(x=>'<tr><td>'+esc(x.full_name)+'</td><td>'+esc(x.email||'')+'</td><td>'+esc(x.role)+'</td><td>'+(x.active?'Aktif':'Nonaktif')+'</td><td>'+
      '<button type="button" data-edit-user="'+esc(x.user_id)+'">Edit</button> '+
      '<button type="button" data-toggle-user="'+esc(x.user_id)+'">'+(x.active?'Nonaktifkan':'Aktifkan')+'</button>'+
    '</td></tr>').join('')+
    '</tbody></table></div>'+(!rows.length?'<p>Belum ada pengguna.</p>':'')+'</section>';

  html+='<section class="panel" id="editUserPanel" hidden><h3>Edit Pengguna</h3>'+
    '<form id="editUserForm" class="form-vertical">'+
      '<input type="hidden" name="user_id">'+
      '<label>Nama<input name="name" required></label>'+
      '<label>Email<input name="email" type="email" readonly></label>'+
      '<label>Role<select name="role">'+rolesList.map(r=>'<option value="'+r+'">'+r+'</option>').join('')+'</select></label>'+
      '<label>Status<select name="active"><option value="true">Aktif</option><option value="false">Nonaktif</option></select></label>'+
      '<button type="submit">Simpan Perubahan</button>'+
      '<button type="button" id="cancelUserEdit">Batal</button>'+
    '</form></section>';

  layout(html);
  attachListFilter({tableId:'usersMasterTable',fields:[
    {label:'Nama',col:0,placeholder:'Nama pengguna'},
    {label:'Email',col:1,placeholder:'Email'},
    {label:'Role',col:2,type:'select',options:rolesList},
    {label:'Status',col:3,type:'select',options:['Aktif','Nonaktif']}
  ]});
  if(error)msg(error.message);

  document.querySelectorAll('[data-toggle-user-password]').forEach(btn=>btn.onclick=()=>{
    const input=document.getElementById(btn.dataset.toggleUserPassword);
    if(!input)return;
    const show=input.type==='password';
    input.type=show?'text':'password';
    btn.textContent=show?'Tutup':'Lihat';
  });

  document.getElementById('createUserForm').onsubmit=async ev=>{
    ev.preventDefault();
    const form=ev.currentTarget;
    const fd=new FormData(form);
    const p1=fd.get('password');
    const p2=fd.get('confirm_password');
    if(p1!==p2)return msg('Konfirmasi password tidak sama.');
    if(String(p1).length<8)return msg('Password minimal 8 karakter.');

    const {data:fnData,error:fnError}=await db.functions.invoke('admin-create-bms-user',{
      body:{
        name:fd.get('name'),
        email:fd.get('email'),
        role:fd.get('role'),
        password:p1
      }
    });
    if(fnError)return msg(fnError.message);
    if(fnData?.error)return msg(fnData.error);
    await users();
    msg('Pengguna berhasil dibuat dan langsung aktif.',true);
  };

  const panel=document.getElementById('editUserPanel');
  const editForm=document.getElementById('editUserForm');
  document.getElementById('cancelUserEdit').onclick=()=>{panel.hidden=true;editForm.reset();};

  root.querySelectorAll('[data-edit-user]').forEach(btn=>btn.onclick=()=>{
    const x=rows.find(v=>v.user_id===btn.dataset.editUser);if(!x)return;
    editForm.elements.user_id.value=x.user_id;
    editForm.elements.name.value=x.full_name||'';
    editForm.elements.email.value=x.email||'';
    editForm.elements.role.value=x.role;
    editForm.elements.active.value=String(!!x.active);
    panel.hidden=false;
    panel.scrollIntoView({behavior:'smooth',block:'start'});
  });

  root.querySelectorAll('[data-toggle-user]').forEach(btn=>btn.onclick=async()=>{
    const x=rows.find(v=>v.user_id===btn.dataset.toggleUser);if(!x)return;
    const {error}=await db.rpc('admin_update_bms_user',{
      p_user_id:x.user_id,
      p_name:x.full_name,
      p_role:x.role,
      p_active:!x.active
    });
    if(error)return msg(error.message);
    await users();
    msg(x.active?'Pengguna dinonaktifkan.':'Pengguna diaktifkan kembali.',true);
  });

  editForm.onsubmit=async ev=>{
    ev.preventDefault();
    const fd=new FormData(editForm);
    const {error}=await db.rpc('admin_update_bms_user',{
      p_user_id:fd.get('user_id'),
      p_name:fd.get('name'),
      p_role:fd.get('role'),
      p_active:fd.get('active')==='true'
    });
    if(error)return msg(error.message);
    await users();
    msg('Data pengguna diperbarui.',true);
  };
}


function renderDashboardTemplate(cfg){
  const kpis=(cfg.kpis||[]).slice(0,4);
  const kpiHtml=kpis.map(x=>'<div class="card">'+esc(x.label||'')+'<strong>'+(x.value||'-')+'</strong><small>'+esc(x.small||'')+'</small></div>').join('');
  layout('<section class="owner-hero"><div><span class="owner-eyebrow">'+esc(cfg.eyebrow||'')+'</span><h3>'+esc(cfg.heading||'Dashboard')+'</h3><p>'+esc(cfg.subtitle||'')+'</p></div><span class="owner-live">LIVE DATA</span></section>'+
    '<section class="cards owner-kpis">'+kpiHtml+'</section>'+
    '<section class="owner-grid-main"><div class="panel owner-performance"><div class="owner-section-title"><div><h3>'+esc(cfg.mainTitle||'Ringkasan Utama')+'</h3><p class="muted">'+esc(cfg.mainSubtitle||'')+'</p></div></div>'+(cfg.mainHtml||'<p class="muted">Belum ada data.</p>')+'</div>'+
    '<div class="panel owner-alert-panel"><h3>'+esc(cfg.attentionTitle||'Perlu Perhatian')+'</h3><p class="muted">'+esc(cfg.attentionSubtitle||'')+'</p>'+(cfg.attentionHtml||'<div class="owner-empty-ok">Tidak ada perhatian utama.</div>')+'</div></section>'+
    '<section class="panel"><div class="owner-section-title"><div><h3>'+esc(cfg.detailTitle||'Detail Operasional')+'</h3><p class="muted">'+esc(cfg.detailSubtitle||'')+'</p></div>'+(cfg.detailBadge||'')+'</div>'+(cfg.detailHtml||'<p class="muted">Belum ada detail tambahan.</p>')+'</section>'+
    '<section class="panel owner-league"><div class="owner-section-title"><div><h3>'+esc(cfg.bottomTitle||'Ringkasan')+'</h3><p class="muted">'+esc(cfg.bottomSubtitle||'')+'</p></div>'+(cfg.bottomBadge||'')+'</div>'+(cfg.bottomHtml||'<p class="muted">Belum ada ringkasan tambahan.</p>')+'</section>');
}

async function buildDashboardModel(){
  const d=await productionBase();
  const leagueSetting=await loadAbkLeagueSetting();
  const [rr,sr,er,esr,abr,absr,cr,br,rhppFinalR]=await Promise.all([
    db.from('recordings').select('*').not('contract_assignment_id','is',null).order('recorded_on',{ascending:true}),
    db.from('recording_weight_samples').select('*'),
    db.from('production_estimates').select('*').order('estimated_on',{ascending:false}),
    db.from('production_estimate_sizes').select('*'),
    db.from('production_abk_results').select('*'),
    db.from('production_abk_result_sizes').select('*'),
    db.from('contracts').select('id,doc_price,pre_starter_price,starter_price,finisher_price'),
    db.from('contract_bonuses').select('contract_id,metric,min_value,max_value,rupiah_per_kg'),
    db.from('rhpp_system_final').select('contract_assignment_id,chick_in_birds,depletion_birds,total_harvest_birds,total_harvest_kg,weighted_age,net_feed_kg,ip,closed_on')
  ]);
  const err=[{error:d.err},rr,sr,er,esr,abr,absr,cr,br,rhppFinalR].find(x=>x?.error)?.error;
  const recs=rr.data||[],samples=sr.data||[],estimates=er.data||[],estSizes=esr.data||[],abkResults=(abr.data||[]).filter(x=>String(x.harvest_date||'')>=(leagueSetting.data?.season_start||'0000-00-00')),abkSizes=absr.data||[],costContracts=cr.data||[],bonusRows=br.data||[],rhppFinalRows=rhppFinalR.data||[];
  const active=d.assignments.filter(a=>a.active&&d.chicks.some(ci=>ci.contract_assignment_id===a.id));
  const ownerParityIssue=profile.role==='OWNER'&&(
    (!d.assignments.length&&(recs.length||estimates.length||abkResults.length))||
    (!d.chicks.length&&recs.length)
  );
  if(ownerParityIssue){
    return {
      eyebrow:'OWNER · PRODUKSI',
      heading:'Production Command Center',
      subtitle:'Pantau performa kandang, estimasi, dan Liga ABK dalam satu layar.',
      kpis:[
        {label:'Kandang Aktif',value:'-',small:'periode berjalan'},
        {label:'Kandang Rehat',value:'-',small:'tidak ada periode aktif'},
        {label:'Total Populasi Berjalan',value:'-',small:'ekor · seluruh kandang aktif'},
        {label:'IP Kumulatif yang Close',value:'-',small:'rata-rata tertimbang RHPP closed'}
      ],
      mainTitle:'Performa Kandang Terbaru',
      mainSubtitle:'Recording terakhir setiap kandang aktif; tanggal ditampilkan per kandang.',
      mainHtml:'<p class="muted">Data Owner belum lengkap. Muat ulang aplikasi agar hak akses terbaru terbaca.</p>',
      attentionTitle:'Perlu Perhatian',
      attentionSubtitle:'Prioritas dari Estimasi Produksi Berjalan, lalu alert performa.',
      attentionHtml:'<div class="owner-alert-row warning"><span>!</span><div><strong>Sinkronisasi data</strong><small>Data Owner belum lengkap.</small></div></div>',
      detailTitle:'Estimasi per Kandang',
      detailSubtitle:'Estimasi produksi terakhir yang tersimpan.',
      detailHtml:'<p class="muted">Data estimasi belum dapat ditampilkan.</p>',
      bottomTitle:'Klasemen Performa ABK',
      bottomSubtitle:'Bobot: Pendapatan/Ekor 50% · FCR 30% · IP 20%',
      bottomBadge:'<span class="owner-trophy">🏆</span>',
      bottomHtml:'<p class="muted">Data klasemen belum dapat ditampilkan.</p>'
    };
  }

  const metrics=active.map(a=>{
    const ci=d.chicks.find(x=>x.contract_assignment_id===a.id);
    const rows=recs.filter(x=>x.contract_assignment_id===a.id).sort((u,v)=>prodNum(u.age_days)-prodNum(v.age_days));
    const latest=rows[rows.length-1]||null,prev=rows[rows.length-2]||null;
    const initial=Math.max(0,prodNum(ci?.received)-prodNum(ci?.doa));
    const dead=rows.reduce((s,x)=>s+prodNum(x.mortality)+prodNum(x.culling),0);
    const feed=rows.reduce((s,x)=>s+prodNum(x.feed_kg),0);
    const population=Math.max(0,initial-dead);
    const ws=latest?samples.filter(s=>s.recording_id===latest.id).map(s=>prodNum(s.weight_g)):[];
    const bwg=ws.length?ws.reduce((s,x)=>s+x,0)/ws.length:prodNum(latest?.avg_weight_kg)*1000;
    const bw=bwg/1000,biomass=population*bw;
    const fcr=biomass>0?feed/biomass:0;
    const dep=initial>0?dead/initial*100:0;
    const age=prodNum(latest?.age_days);
    const ip=age>0&&fcr>0?((100-dep)*bw*100)/(age*fcr):0;
    const prevWs=prev?samples.filter(s=>s.recording_id===prev.id).map(s=>prodNum(s.weight_g)):[];
    const prevBwg=prevWs.length?prevWs.reduce((s,x)=>s+x,0)/prevWs.length:prodNum(prev?.avg_weight_kg)*1000;
    const st=d.standards.find(s=>s.contract_id===a.master_contract_id&&s.template_name===a.performance_template_name&&prodNum(s.age_days)===age);
    const fc=initial>0?feed*1000/initial:0;
    const fcStd=prodNum(st?.std_feed_g_per_bird);
    const fcLow=!!(latest&&fcStd>0&&fc<fcStd);
    const alerts=[];
    if(!latest)alerts.push('Belum recording');
    if(latest&&st?.std_body_weight_g&&bwg<prodNum(st.std_body_weight_g))alerts.push('BW di bawah standar');
    if(latest&&st?.std_fcr&&fcr>prodNum(st.std_fcr))alerts.push('FCR di atas standar');
    if(fcLow)alerts.push('FC di bawah standar');
    return {a,ci,latest,initial,population,feed,fc,fcStd,fcLow,bwg,bw,fcr,dep,age,ip,prevBwg,st,alerts};
  });
  const valid=metrics.filter(x=>x.latest);
  const avg=k=>valid.length?valid.reduce((s,x)=>s+prodNum(x[k]),0)/valid.length:0;
  const ownerActiveBarnIds=new Set(active.map(a=>a.barn_id));
  const ownerRestingBarnCount=d.barns.filter(b=>b.active!==false&&!ownerActiveBarnIds.has(b.id)).length;
  const ownerRunningPopulation=metrics.reduce((sum,x)=>sum+prodNum(x.population),0);
  const ownerClosedRhpp=rhppFinalRows.filter(x=>prodNum(x.total_harvest_birds)>0);
  const ownerClosedTotals=ownerClosedRhpp.reduce((o,x)=>{
    const birds=prodNum(x.total_harvest_birds);
    o.chickIn+=prodNum(x.chick_in_birds);
    o.depletion+=prodNum(x.depletion_birds);
    o.birds+=birds;
    o.kg+=prodNum(x.total_harvest_kg);
    o.feed+=prodNum(x.net_feed_kg);
    o.ageWeight+=prodNum(x.weighted_age)*Math.max(1,birds);
    return o;
  },{chickIn:0,depletion:0,birds:0,kg:0,feed:0,ageWeight:0});
  const ownerClosedAge=ownerClosedTotals.birds>0?ownerClosedTotals.ageWeight/ownerClosedTotals.birds:0;
  const ownerClosedAvg=ownerClosedTotals.birds>0?ownerClosedTotals.kg/ownerClosedTotals.birds:0;
  const ownerClosedFcr=ownerClosedTotals.kg>0?ownerClosedTotals.feed/ownerClosedTotals.kg:0;
  const ownerClosedSurvival=ownerClosedTotals.chickIn>0
    ?Math.min(100,(ownerClosedTotals.chickIn-ownerClosedTotals.depletion)/ownerClosedTotals.chickIn*100)
    :0;
  const ownerClosedIpTotal=ownerClosedAge&&ownerClosedFcr&&ownerClosedAvg
    ?(ownerClosedSurvival*ownerClosedAvg*100)/(ownerClosedAge*ownerClosedFcr)
    :0;

  const performanceCards=metrics.map(x=>{
    const b=d.barns.find(v=>v.id===x.a.barn_id);
    const trend=!x.latest?'':x.prevBwg?(x.bwg>x.prevBwg?'↑':x.bwg<x.prevBwg?'↓':'→'):'→';
    const isSim=String(x.latest?.notes||'').includes('SIMULASI DASHBOARD KPI'); const alert=isSim?'<span class="owner-sim">SIMULASI</span>':(x.alerts.length?'<span class="owner-alert">'+esc(x.alerts[0])+'</span>':'<span class="owner-ok">Normal</span>');
    return '<article class="owner-barn-card"><div class="owner-barn-head"><div><strong>'+esc(b?shortBarnLabel(b):'-')+'</strong><small>Hari '+(x.age||'-')+' · '+(x.latest?prodDateId(x.latest.recorded_on):'-')+'</small></div>'+alert+'</div>'+
      '<div class="owner-metrics"><div><span>Populasi</span><b>'+prodFmt(x.population,0)+'</b></div><div><span>BW</span><b>'+prodFmt(x.bw,3)+' kg '+trend+'</b></div><div><span>FCR</span><b>'+prodFmt(x.fcr,3)+'</b></div><div><span>IP</span><b>'+prodFmt(x.ip,1)+'</b></div></div>'+
      '<div class="owner-card-foot">Deplesi '+prodFmt(x.dep,2)+'% · <span class="'+(x.fcLow?'owner-fc-low':'owner-fc-ok')+'">FC '+prodFmt(x.fc,0)+' g/ekor'+(x.fcStd>0?' / Std '+prodFmt(x.fcStd,0):'')+'</span> · Pakan '+prodFmt(x.feed,0)+' Kg</div></article>';
  }).join('');

  const latestEst=active.map(a=>estimates.find(e=>e.contract_assignment_id===a.id)).filter(Boolean);
  const estimateRows=latestEst.map(e=>{
    const a=active.find(x=>x.id===e.contract_assignment_id),b=d.barns.find(x=>x.id===a?.barn_id),ci=d.chicks.find(x=>x.contract_assignment_id===a?.id);
    const sz=estSizes.filter(s=>s.estimate_id===e.id);
    const birds=sz.reduce((s,x)=>s+prodNum(x.birds),0),bio=sz.reduce((s,x)=>s+prodNum(x.birds)*prodNum(x.bw_kg),0);
    const bw=birds?bio/birds:0,age=ci?prodAge(ci.arrived_on,e.estimated_on):0;
    const priorHarvests=d.harvests.filter(h=>h.contract_assignment_id===e.contract_assignment_id&&h.harvested_on<e.estimated_on);
    const harvBirds=priorHarvests.reduce((s,h)=>s+prodNum(h.birds),0),harvKg=priorHarvests.reduce((s,h)=>s+prodNum(h.net_weight_kg),0);
    const totalProjectedBirds=harvBirds+birds,totalProjectedBio=harvKg+bio;
    const fcr=totalProjectedBio?prodNum(e.feed_used_kg)/totalProjectedBio:0;
    const initial=ci?prodNum(ci.received)-prodNum(ci.doa):0;
    const surv=initial?Math.min(100,totalProjectedBirds/initial*100):0;
    const avgProjectedBw=totalProjectedBirds?totalProjectedBio/totalProjectedBirds:0;
    const ip=age&&fcr?(surv*avgProjectedBw*100)/(age*fcr):0;
    return '<tr><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td>'+prodDateId(e.estimated_on)+'</td><td>'+age+' hari</td><td class="num">'+prodFmt(e.remaining_birds,0)+'</td><td class="num">'+prodFmt(bw,3)+'</td><td class="num">'+prodFmt(prodNum(e.feed_used_kg)/50,0)+' zak</td><td class="num">'+prodFmt(fcr,3)+'</td><td class="num">'+prodFmt(ip,1)+'</td><td class="num">Rp '+prodFmt(e.profit_per_chick_in,0)+'</td></tr>';
  }).join('');
  const estimateCards=latestEst.map(e=>{
    const a=active.find(x=>x.id===e.contract_assignment_id),b=d.barns.find(x=>x.id===a?.barn_id),ci=d.chicks.find(x=>x.contract_assignment_id===a?.id);
    const sz=estSizes.filter(s=>s.estimate_id===e.id);
    const birds=sz.reduce((s,x)=>s+prodNum(x.birds),0),bio=sz.reduce((s,x)=>s+prodNum(x.birds)*prodNum(x.bw_kg),0);
    const bw=birds?bio/birds:0,age=ci?prodAge(ci.arrived_on,e.estimated_on):0;
    const priorHarvests=d.harvests.filter(h=>h.contract_assignment_id===e.contract_assignment_id&&h.harvested_on<e.estimated_on);
    const harvBirds=priorHarvests.reduce((s,h)=>s+prodNum(h.birds),0),harvKg=priorHarvests.reduce((s,h)=>s+prodNum(h.net_weight_kg),0);
    const totalProjectedBirds=harvBirds+birds,totalProjectedBio=harvKg+bio;
    const fcr=totalProjectedBio?prodNum(e.feed_used_kg)/totalProjectedBio:0;
    const initial=ci?prodNum(ci.received)-prodNum(ci.doa):0;
    const surv=initial?Math.min(100,totalProjectedBirds/initial*100):0;
    const avgProjectedBw=totalProjectedBirds?totalProjectedBio/totalProjectedBirds:0;
    const ip=age&&fcr?(surv*avgProjectedBw*100)/(age*fcr):0;
    return '<article class="owner-mobile-card"><div class="owner-mobile-card-head"><strong>'+esc(b?shortBarnLabel(b):'-')+'</strong><span>'+age+' hari</span></div>'+
      '<div class="owner-mobile-metrics"><div><span>Sisa Ayam</span><b>'+prodFmt(e.remaining_birds,0)+'</b></div><div><span>BW Est.</span><b>'+prodFmt(bw,3)+' kg</b></div><div><span>Pakan</span><b>'+prodFmt(prodNum(e.feed_used_kg)/50,0)+' zak</b></div><div><span>FCR Est.</span><b>'+prodFmt(fcr,3)+'</b></div><div><span>IP Est.</span><b>'+prodFmt(ip,1)+'</b></div><div><span>Laba/Ekor</span><b>Rp '+prodFmt(e.profit_per_chick_in,0)+'</b></div></div>'+
      '<small>'+prodDateId(e.estimated_on)+'</small></article>';
  }).join('');

  const leagueRaw=abkResults.map(x=>{
    const a=d.assignments.find(v=>v.id===x.contract_assignment_id),ci=d.chicks.find(v=>v.contract_assignment_id===x.contract_assignment_id),link=d.links.find(v=>v.contract_assignment_id===x.contract_assignment_id&&v.abk_id===x.abk_id);
    const sz=abkSizes.filter(v=>v.result_id===x.id);
    const birds=sz.reduce((s,v)=>s+prodNum(v.birds),0),kg=sz.reduce((s,v)=>s+prodNum(v.weight_kg),0),bw=birds?kg/birds:0;
    const feed=(prodNum(link?.feed_pre_bags)+prodNum(link?.feed_starter_bags)+prodNum(link?.feed_finisher_bags))*50;
    const fcr=kg?feed/kg:0;
    const age=birds&&ci?sz.reduce((s,v)=>s+prodAge(ci.arrived_on,v.harvest_date)*prodNum(v.birds),0)/birds:0;
    const initial=prodNum(link?.initial_birds),surv=initial?Math.min(100,birds/initial*100):0;
    const ip=initial&&age&&fcr?(surv*bw*100)/(age*fcr):0;
    let revenue=0;
    for(const s of sz){
      const av=prodNum(s.birds)?prodNum(s.weight_kg)/prodNum(s.birds):0;
      const p=d.livePrices.find(p=>p.contract_id===a?.master_contract_id&&av>=prodNum(p.min_weight_kg)&&(p.max_weight_kg==null||av<prodNum(p.max_weight_kg)));
      revenue+=prodNum(s.weight_kg)*prodNum(p?.price_per_kg);
    }
    const cc=costContracts.find(v=>v.id===a?.master_contract_id);
    const cost=initial*prodNum(cc?.doc_price)+prodNum(link?.feed_pre_bags)*50*prodNum(cc?.pre_starter_price)+prodNum(link?.feed_starter_bags)*50*prodNum(cc?.starter_price)+prodNum(link?.feed_finisher_bags)*50*prodNum(cc?.finisher_price);
    const match=(metric,value)=>prodNum(bonusRows.find(v=>v.contract_id===a?.master_contract_id&&v.metric===metric&&(v.min_value==null||value>=prodNum(v.min_value))&&(v.max_value==null||value<prodNum(v.max_value)))?.rupiah_per_kg);
    const ipBonus=kg*match('IP',ip);
    const profit=revenue-cost+ipBonus;
    const perBird=birds?profit/birds:0;
    return {...x,a,birds,kg,bw,fcr,ip,perBird,feed,profit,initialPopulation:initial,complete:!!link?.basics_locked_at&&initial>0&&birds>0&&kg>0&&feed>0};
  }).filter(x=>x.complete);
  const leagueMap=new Map();
  leagueRaw.forEach(x=>{
    const key=x.abk_id;
    if(!leagueMap.has(key))leagueMap.set(key,{...x,birds:0,harvestBirds:0,kg:0,feed:0,profit:0,ipWeighted:0,totalPopulation:0,periods:0});
    const g=leagueMap.get(key);
    g.birds+=prodNum(x.birds);
    g.harvestBirds=(prodNum(g.harvestBirds)+prodNum(x.birds));
    g.kg+=prodNum(x.kg);
    g.feed+=prodNum(x.feed);
    g.profit+=prodNum(x.profit);
    g.totalPopulation+=prodNum(x.initialPopulation);
    g.ipWeighted+=prodNum(x.ip)*prodNum(x.birds);
    g.periods+=1;
    g.a=x.a;
  });
  const league=[...leagueMap.values()].map(g=>({
    ...g,
    bw:g.birds?g.kg/g.birds:0,
    fcr:g.kg?g.feed/g.kg:0,
    ip:g.birds?g.ipWeighted/g.birds:0,
    perBird:g.birds?g.profit/g.birds:0
  })).filter(g=>d.abks.find(e=>e.id===g.abk_id)?.active!==false);
  const max=k=>Math.max(...league.map(x=>prodNum(x[k])),0),min=k=>Math.min(...league.map(x=>prodNum(x[k])).filter(v=>v>0),0);
  league.forEach(x=>{const hi=k=>max(k)?prodNum(x[k])/max(k):0,lo=k=>prodNum(x[k])>0&&min(k)>0?min(k)/prodNum(x[k]):0;x.score=hi('perBird')*.50+lo('fcr')*.30+hi('ip')*.20});
  league.sort((a,b)=>b.score-a.score);
  const leagueRows=league.map((x,i)=>{
    const e=d.abks.find(v=>v.id===x.abk_id),b=d.barns.find(v=>v.id===x.a?.barn_id);
    const medal=i===0?'🥇':i===1?'🥈':i===2?'🥉':String(i+1);
    return '<tr><td class="owner-rank">'+medal+'</td><td>'+esc(leagueAbkName(e))+'</td><td>'+esc(b?shortBarnLabel(b):'-')+'</td><td class="num"><strong>'+prodFmt(x.periods,0)+'</strong></td><td class="num">'+prodFmt(x.totalPopulation,0)+'</td><td class="num">'+prodFmt(x.harvestBirds,0)+'</td><td class="num">Rp '+prodFmt(x.perBird,0)+'</td><td class="num">'+prodFmt(x.ip,1)+'</td><td class="num">'+prodFmt(x.fcr,3)+'</td><td class="num">'+prodFmt(x.bw,3)+'</td></tr>';
  }).join('');
  const leagueCards=league.map((x,i)=>{
    const e=d.abks.find(v=>v.id===x.abk_id),b=d.barns.find(v=>v.id===x.a?.barn_id);
    const medal=i===0?'🥇':i===1?'🥈':i===2?'🥉':String(i+1);
    return '<article class="owner-league-card"><div class="owner-league-rank">'+medal+'</div><div class="owner-league-main"><strong>'+esc(leagueAbkName(e))+'</strong><small>'+esc(b?shortBarnLabel(b):'-')+'</small></div>'+
      '<div class="owner-league-stats"><div><span>Siklus</span><b>'+prodFmt(x.periods,0)+'</b></div><div><span>Populasi</span><b>'+prodFmt(x.totalPopulation,0)+'</b></div><div><span>Ekor Panen</span><b>'+prodFmt(x.harvestBirds,0)+'</b></div><div><span>Rp/Ekor</span><b>'+prodFmt(x.perBird,0)+'</b></div><div><span>IP</span><b>'+prodFmt(x.ip,1)+'</b></div><div><span>FCR</span><b>'+prodFmt(x.fcr,3)+'</b></div><div><span>BW</span><b>'+prodFmt(x.bw,3)+'</b></div></div></article>';
  }).join('');

  const estimateAttention=[];
  const todayIso=prodToday();
  const dayDiff=(a,b)=>Math.floor((new Date(String(b).slice(0,10)+'T00:00:00')-new Date(String(a).slice(0,10)+'T00:00:00'))/86400000);
  active.forEach(a=>{
    const b=d.barns.find(v=>v.id===a.barn_id);
    const name=b?shortBarnLabel(b):'-';
    const e=estimates.find(v=>v.contract_assignment_id===a.id);
    if(!e){
      estimateAttention.push({barn:name,text:'Belum ada estimasi produksi',level:'danger'});
      return;
    }
    const ageDays=dayDiff(e.estimated_on,todayIso);
    if(ageDays>=3)estimateAttention.push({barn:name,text:'Estimasi terakhir '+prodDateId(e.estimated_on)+' · perlu diperbarui',level:'warning'});
    const profit=prodNum(e.estimated_profit),perChick=prodNum(e.profit_per_chick_in);
    if(profit<0)estimateAttention.push({barn:name,text:'Estimasi laba minus Rp '+prodFmt(Math.abs(profit),0),level:'danger'});
    else if(perChick<1000)estimateAttention.push({barn:name,text:'Laba estimasi rendah · Rp '+prodFmt(perChick,0)+'/ekor',level:'warning'});
  });
  const productionAttention=metrics.flatMap(x=>{
    const b=d.barns.find(v=>v.id===x.a.barn_id);
    return x.alerts.map(a=>({barn:b?shortBarnLabel(b):'-',text:a,level:'production'}));
  });
  const attention=[...estimateAttention,...productionAttention].slice(0,8);
  const alertHtml=attention.length?attention.map(x=>'<div class="owner-alert-row '+esc(x.level||'')+'"><span>!</span><div><strong>'+esc(x.barn)+'</strong><small>'+esc(x.text)+'</small></div></div>').join(''):'<div class="owner-empty-ok">Estimasi seluruh kandang aktif masih dalam kondisi normal.</div>';

  return {
    eyebrow:'OWNER · PRODUKSI',
    heading:'Production Command Center',
    subtitle:'Pantau performa kandang, estimasi, dan Liga ABK dalam satu layar.',
    kpis:[
      {label:'Kandang Aktif',value:String(active.length),small:'periode berjalan'},
      {label:'Kandang Rehat',value:String(ownerRestingBarnCount),small:'tidak ada periode aktif'},
      {label:'Total Populasi Berjalan',value:prodFmt(ownerRunningPopulation,0),small:'ekor · seluruh kandang aktif'},
      {label:'IP Kumulatif yang Close',value:prodFmt(ownerClosedIpTotal,2),small:'rata-rata tertimbang RHPP closed'}
    ],
    mainTitle:'Performa Kandang Terbaru',
    mainSubtitle:'Recording terakhir setiap kandang aktif; tanggal ditampilkan per kandang.',
    mainHtml:'<div class="owner-barn-grid">'+(performanceCards||'<p class="muted">Belum ada kandang aktif.</p>')+'</div>',
    attentionTitle:'Perlu Perhatian',
    attentionSubtitle:'Prioritas dari Estimasi Produksi Berjalan, lalu alert performa.',
    attentionHtml:alertHtml,
    detailTitle:'Estimasi per Kandang',
    detailSubtitle:'Estimasi produksi terakhir yang tersimpan.',
    detailBadge:'<span class="pill">'+latestEst.length+' estimasi</span>',
    detailHtml:'<div class="owner-desktop-only tablewrap owner-estimate-scroll"><table class="owner-table"><thead><tr><th>Kandang</th><th>Tanggal</th><th>Umur</th><th class="num">Sisa Ayam</th><th class="num">BW Est.</th><th class="num">Pakan</th><th class="num">FCR Est.</th><th class="num">IP Est.</th><th class="num">Laba / Ekor Chick-In</th></tr></thead><tbody>'+estimateRows+'</tbody></table></div><div class="owner-mobile-only owner-mobile-list">'+estimateCards+'</div>'+(latestEst.length?'':'<p class="muted">Belum ada estimasi aktif.</p>'),
    bottomTitle:'Klasemen Performa ABK',
    bottomSubtitle:'Musim sejak '+prodDateId(leagueSetting.data?.season_start||'')+' · Bobot: Pendapatan/Ekor 50% · FCR 30% · IP 20%',
    bottomBadge:'<span class="owner-trophy">🏆</span>',
    bottomHtml:'<div class="owner-desktop-only tablewrap"><table class="owner-table"><thead><tr><th>Peringkat</th><th>ABK</th><th>Kandang Terakhir</th><th class="num">Siklus</th><th class="num">Total Populasi</th><th class="num">Total Ekor Panen</th><th class="num">Pendapatan/Ekor</th><th class="num">IP</th><th class="num">FCR</th><th class="num">BW</th></tr></thead><tbody>'+leagueRows+'</tbody></table></div><div class="owner-mobile-only owner-league-mobile">'+leagueCards+'</div>'+(league.length?'':'<p class="muted">Belum ada hasil Liga ABK yang lengkap.</p>')
  };
  if(err)msg(err.message);
}












async function dashboard(){
  const model=await buildDashboardModel();
  if(tab!=='dashboard'||!model)return;
  model.eyebrow=profile.role==='OWNER'?'OWNER · PRODUKSI':profile.role;
  renderDashboardTemplate(model);
}

async function marketingReports(){
  const [br,ar,cr,hr,mr,sr,cpr]=await Promise.all([
    db.from('barns').select('id,code,name').order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active').order('start_date',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('marketing_contract_harvests').select('*').order('harvested_on',{ascending:false}),
    db.from('marketing_external_meat_purchases').select('*').order('purchase_date',{ascending:false}),
    db.from('suppliers').select('id,code,name,supplier_type').eq('supplier_type','DAGING').order('code',{ascending:true}),
    db.from('company_profile').select('company_name,legal_name,logo_url,address,phone,email').eq('id',true).maybeSingle()
  ]);
  const barns=br.data||[], assignments=ar.data||[], contractsRows=cr.data||[], harvests=hr.data||[], meatRows=mr.data||[], suppliers=sr.data||[], company=cpr.data||{};
  const assignmentById=new Map(assignments.map(a=>[a.id,a]));

  let html='<section class="panel"><h3>Laporan Marketing</h3>'+
    '<form id="marketingReportFilter" class="form-vertical">'+
      '<label>Tanggal Awal<input type="date" name="date_from"></label>'+
      '<label>Tanggal Akhir<input type="date" name="date_to"></label>'+
      '<label>Cari / Pilih Kandang<input id="marketingReportBarnSearch" autocomplete="off" placeholder="Kosong = Semua Kandang"></label>'+
      '<input type="hidden" name="barn_id" id="marketingReportBarnId">'+
      '<div id="marketingReportBarnSuggestions" class="search-suggestions"></div>'+
      '<button type="button" id="marketingReportAllBarns">Semua Kandang</button>'+
      '<label>Siklus<select name="assignment_id" id="marketingReportCycle" disabled><option value="">Semua Siklus</option></select></label>'+
      '<label>Jenis<select name="kind"><option value="">Semua</option><option value="PANEN">Panen Kontrak</option><option value="DAGING">Tambah Daging</option></select></label>'+
      '<button type="submit">Tampilkan</button>'+
    '</form></section>'+
    '<section class="panel" id="marketingReportOutput" style="display:none"><div id="marketingReportSummary"></div>'+
      '<div class="report-actions"><button type="button" id="marketingPrint">Cetak</button> <button type="button" id="marketingPdf">PDF</button> <button type="button" id="marketingExcel">Excel</button></div>'+
      '<div id="marketingReportSections"></div>'+
      '<p id="marketingReportEmpty" class="muted"></p>'+
    '</section>';
  layout(html);
  [br,ar,cr,hr,mr,sr,cpr].forEach(x=>{if(x.error)msg(x.error.message)});

  const marketingReportBarnSearch=document.getElementById('marketingReportBarnSearch');
  const marketingReportBarnId=document.getElementById('marketingReportBarnId');
  const marketingReportBarnSuggestions=document.getElementById('marketingReportBarnSuggestions');
  const marketingReportCycle=document.getElementById('marketingReportCycle');
  const syncMarketingCycles=()=>{
    const bid=marketingReportBarnId?.value||'';
    const rows=bid?assignments.filter(a=>a.barn_id===bid):[];
    if(marketingReportCycle){
      marketingReportCycle.disabled=!bid;
      marketingReportCycle.innerHTML='<option value="">Semua Siklus</option>'+rows.map(a=>'<option value="'+esc(a.id)+'">'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED'))+'</option>').join('');
    }
  };
  if(marketingReportBarnSearch&&marketingReportBarnId&&marketingReportBarnSuggestions){
    marketingReportBarnSearch.oninput=()=>{
      const q=(marketingReportBarnSearch.value||'').trim().toLowerCase();
      marketingReportBarnId.value='';
      syncMarketingCycles();
      const rows=q?barns.filter(b=>[b.code,b.name].filter(Boolean).join(' ').toLowerCase().includes(q)).slice(0,5):[];
      marketingReportBarnSuggestions.innerHTML=rows.map(b=>'<button type="button" class="search-suggestion" data-marketing-report-barn="'+esc(b.id)+'"><strong>'+esc(shortBarnLabel(b))+'</strong></button>').join('');
      if(q&&!rows.length)marketingReportBarnSuggestions.innerHTML='<div class="search-empty">Kandang tidak ditemukan.</div>';
      marketingReportBarnSuggestions.querySelectorAll('[data-marketing-report-barn]').forEach(btn=>btn.onclick=()=>{
        const b=barns.find(x=>x.id===btn.dataset.marketingReportBarn);if(!b)return;
        marketingReportBarnId.value=b.id;marketingReportBarnSearch.value=shortBarnLabel(b);marketingReportBarnSuggestions.innerHTML='';syncMarketingCycles();
      });
    };
    document.getElementById('marketingReportAllBarns').onclick=()=>{
      marketingReportBarnId.value='';marketingReportBarnSearch.value='';marketingReportBarnSuggestions.innerHTML='';syncMarketingCycles();
    };
  }

  let filteredHarvests=[],filteredMeat=[];

  const renderRows=()=>{
    const output=document.getElementById('marketingReportOutput');
    if(output)output.style.display='';
    const fd=new FormData(document.getElementById('marketingReportFilter'));
    const from=String(fd.get('date_from')||''),to=String(fd.get('date_to')||''),barnId=String(fd.get('barn_id')||''),assignmentId=String(fd.get('assignment_id')||''),kind=String(fd.get('kind')||'');
    filteredHarvests=kind==='DAGING'?[]:harvests.filter(x=>(!from||x.harvested_on>=from)&&(!to||x.harvested_on<=to)&&(!barnId||x.barn_id===barnId)&&(!assignmentId||x.contract_assignment_id===assignmentId));
    filteredMeat=kind==='PANEN'?[]:meatRows.filter(x=>(!from||x.purchase_date>=from)&&(!to||x.purchase_date<=to)&&(!barnId||x.barn_id===barnId)&&(!assignmentId||x.contract_assignment_id===assignmentId));

    const harvestKg=filteredHarvests.reduce((n,x)=>n+Number(x.net_weight_kg||0),0);
    const birds=filteredHarvests.reduce((n,x)=>n+Number(x.birds||0),0);
    const harvestValue=filteredHarvests.reduce((n,x)=>n+Number(x.total_amount||0),0);
    const meatKg=filteredMeat.reduce((n,x)=>n+Number(x.weight_kg||0),0);
    const meatCost=filteredMeat.reduce((n,x)=>n+Number(x.weight_kg||0)*Number(x.purchase_price_per_kg||0),0);

    document.getElementById('marketingReportSummary').innerHTML=
      '<div class="tablewrap"><table><tbody>'+
      '<tr><th>Panen Kontrak</th><td>'+fmtNumber(birds)+' ekor</td><td>'+fmtNumber(harvestKg)+' Kg</td><td>Rp '+fmtNumber(harvestValue)+'</td></tr>'+
      '<tr><th>Tambah Daging</th><td>-</td><td>'+fmtNumber(meatKg)+' Kg</td><td>Rp '+fmtNumber(meatCost)+'</td></tr>'+
      '</tbody></table></div>';

    const harvestTable=filteredHarvests.length?'<section class="report-section-block"><h3>PANEN KONTRAK</h3><div class="tablewrap"><table class="marketingReportTable"><thead><tr><th>Tanggal</th><th>Kandang</th><th>Kontrak</th><th>Ekor</th><th>Kg</th><th>Avg Kg</th><th>Harga/Kg</th><th>Total</th><th>Pembeli</th><th>Referensi</th></tr></thead><tbody>'+
      filteredHarvests.map(x=>{const b=barns.find(v=>v.id===x.barn_id),a=assignmentById.get(x.contract_assignment_id),k=contractsRows.find(v=>v.id===a?.master_contract_id);return '<tr><td>'+esc(x.harvested_on||'')+'</td><td>'+esc(assignmentIdentity(assignments,barns,contractsRows,a))+'</td><td>'+esc(shortContractLabel(k?.number)||'-')+'</td><td>'+fmtNumber(x.birds)+'</td><td>'+fmtNumber(x.net_weight_kg)+'</td><td>'+fmtNumber(x.avg_weight_kg)+'</td><td>'+fmtNumber(x.price_per_kg)+'</td><td>'+fmtNumber(x.total_amount)+'</td><td>'+esc(x.buyer_name||'-')+'</td><td>'+esc(x.transaction_number||'-')+'</td></tr>';}).join('')+
      '</tbody></table></div></section>':'';

    const meatTable=filteredMeat.length?'<section class="report-section-block"><h3>TAMBAH DAGING</h3><div class="tablewrap"><table class="marketingReportTable"><thead><tr><th>Tanggal</th><th>Kandang</th><th>Kontrak</th><th>Supplier</th><th>Barang</th><th>Kg</th><th>Harga/Kg</th><th>Total</th><th>Referensi</th></tr></thead><tbody>'+
      filteredMeat.map(x=>{const b=barns.find(v=>v.id===x.barn_id),a=assignmentById.get(x.contract_assignment_id),k=contractsRows.find(v=>v.id===a?.master_contract_id),s=suppliers.find(v=>v.id===x.supplier_id),total=Number(x.weight_kg||0)*Number(x.purchase_price_per_kg||0);return '<tr><td>'+esc(x.purchase_date||'')+'</td><td>'+esc(assignmentIdentity(assignments,barns,contractsRows,a))+'</td><td>'+esc(shortContractLabel(k?.number)||'-')+'</td><td>'+esc(s?.name||'-')+'</td><td>'+esc(x.product_name||'-')+'</td><td>'+fmtNumber(x.weight_kg)+'</td><td>'+fmtNumber(x.purchase_price_per_kg)+'</td><td>'+fmtNumber(total)+'</td><td>'+esc(x.reference_number||'-')+'</td></tr>';}).join('')+
      '</tbody></table></div></section>':'';

    document.getElementById('marketingReportSections').innerHTML=harvestTable+meatTable;
    document.getElementById('marketingReportEmpty').textContent=(filteredHarvests.length||filteredMeat.length)?'':'Tidak ada data sesuai filter.';
  };

  document.getElementById('marketingReportFilter').onsubmit=e=>{e.preventDefault();renderRows();};

  const reportHtml=()=>{
    const fd=new FormData(document.getElementById('marketingReportFilter'));
    const from=fd.get('date_from')||'-',to=fd.get('date_to')||'-',barnId=fd.get('barn_id')||'',kind=fd.get('kind')||'Semua';
    const b=barns.find(x=>x.id===barnId);
    return '<!doctype html><html><head><meta charset="utf-8"><title>Laporan Marketing</title>'+
      '<style>@page{size:A4 landscape;margin:5mm}html,body{margin:0;padding:0;font-family:Arial,sans-serif;font-size:9px;line-height:1.15}h2{margin:0 0 3px;font-size:13px}h3{margin:4px 0 2px;font-size:10px}p{margin:2px 0 4px}table{width:100%;border-collapse:collapse;font-size:8.5px}th,td{border:1px solid #999;padding:2px 3px;text-align:left;white-space:nowrap}thead{display:table-header-group}tr{break-inside:avoid}.print-letterhead{display:flex;align-items:center;gap:8px;border-bottom:1.5px solid #222;padding-bottom:3px;margin-bottom:3px}.print-letterhead img{width:50px;height:50px;object-fit:contain}</style></head><body>'+
      '<div class="print-letterhead">'+'<img src="'+BMS_PRINT_LOGO+'">'+'<div><h2>'+esc(company.company_name||company.legal_name||'Laporan Marketing')+'</h2><div style="white-space:pre-line">'+esc(company.address||'')+'</div>'+(company.phone?'<div>Tel/WA: '+esc(company.phone)+'</div>':'')+(company.email?'<div>'+esc(company.email)+'</div>':'')+'</div></div>'+
      '<h2>Laporan Marketing</h2><p>Periode: '+esc(String(from))+' s/d '+esc(String(to))+' · Kandang: '+esc(b?shortBarnLabel(b):'Semua Kandang')+' · Jenis: '+esc(String(kind))+'</p>'+
      document.getElementById('marketingReportSummary').innerHTML+
      document.getElementById('marketingReportSections').innerHTML+
      '</body></html>';
  };

  const printOpen=(pdf=false)=>{
    renderRows();
    const w=window.open('','_blank');if(!w)return msg('Popup cetak diblokir browser.');
    w.document.write(pdf?reportHtml().replace('<title>Laporan Marketing</title>','<title>Laporan_Marketing_PDF</title>'):reportHtml());w.document.close();
    setTimeout(()=>{w.focus();w.print();},500);
  };
  document.getElementById('marketingPrint').onclick=()=>printOpen(false);
  document.getElementById('marketingPdf').onclick=()=>printOpen(true);
  document.getElementById('marketingExcel').onclick=()=>{
    renderRows();
    const html=document.getElementById('marketingReportSummary').innerHTML+document.getElementById('marketingReportSections').innerHTML;
    const blob=new Blob(['\ufeff<html><head><meta charset="utf-8"></head><body>'+html+'</body></html>'],{type:'application/vnd.ms-excel;charset=utf-8'});
    const url=URL.createObjectURL(blob),a=document.createElement('a');a.href=url;a.download='Laporan_Marketing.xls';document.body.appendChild(a);a.click();a.remove();setTimeout(()=>URL.revokeObjectURL(url),1000);
  };
}

async function logisticsReports(){
  const [br,ir,sr,sir,rr,rir,er,eir,exr,erir,etr,supr,ar,kr,cpr]=await Promise.all([
    db.from('barns').select('id,code,name,location,kind').order('code',{ascending:true}),
    db.from('items').select('id,code,name,category,unit,kg_per_unit').order('code',{ascending:true}),
    db.from('logistics_shipments').select('id,contract_assignment_id,barn_id,shipment_date,shipping_note_number,notes').order('shipment_date',{ascending:false}),
    db.from('logistics_shipment_items').select('shipment_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('logistics_returns').select('id,contract_assignment_id,barn_id,return_date,reference,notes').order('return_date',{ascending:false}),
    db.from('logistics_return_items').select('return_id,item_id,quantity,quantity_kg,unit_price'),
    db.from('logistics_external_shipments').select('id,contract_assignment_id,barn_id,supplier_id,shipment_date,reference_number,notes').order('shipment_date',{ascending:false}),
    db.from('logistics_external_shipment_items').select('id,external_shipment_id,item_id,quantity,quantity_kg,purchase_unit_price'),
    db.from('logistics_external_returns').select('id,contract_assignment_id,barn_id,supplier_id,return_date,reference,notes,status').order('return_date',{ascending:false}),
    db.from('logistics_external_return_items').select('id,external_return_id,external_shipment_item_id,item_id,quantity'),
    db.from('logistics_external_return_transfers').select('id,external_return_item_id,item_id,source_barn_id,target_barn_id,quantity,transferred_on,notes').order('transferred_on',{ascending:false}),
    db.from('suppliers').select('id,code,name,supplier_type').eq('supplier_type','SAPRONAK').order('code',{ascending:true}),
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active').order('start_date',{ascending:false}),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('company_profile').select('company_name,legal_name,logo_url,address,phone,email,website').eq('id',true).maybeSingle()
  ]);

  const barns=br.data||[], itemsAll=ir.data||[], shipments=sr.data||[], shipmentItems=sir.data||[], returns=rr.data||[], returnItems=rir.data||[], externalHeaders=er.data||[], externalItems=eir.data||[], externalReturns=exr.data||[], externalReturnItems=erir.data||[], externalTransfers=etr.data||[], supplierRows=supr.data||[], assignments=ar.data||[], contractsRows=kr.data||[], company=cpr.data||{};
  const shipmentRows=shipmentItems.map(x=>{
    const head=shipments.find(s=>s.id===x.shipment_id);
    const item=itemsAll.find(i=>i.id===x.item_id);
    return head&&item?{
      type:'Pengiriman',
      date:head.shipment_date,
      barn_id:head.barn_id,
      assignment_id:head.contract_assignment_id||'',
      shipping_note_number:head.shipping_note_number||'',
      reference:'',
      item_id:item.id,
      item_code:item.code,
      item_name:item.name,
      category:item.category,
      quantity:x.quantity,
      quantity_kg:x.quantity_kg,
      unit_price:x.unit_price,
      total_value:Number(x.quantity||0)*Number(x.unit_price||0),
      unit:item.unit,
      notes:head.notes||'',
      supplier_name:''
    }:null;
  }).filter(Boolean);

  const returnRows=returnItems.map(x=>{
    const head=returns.find(r=>r.id===x.return_id);
    const item=itemsAll.find(i=>i.id===x.item_id);
    return head&&item?{
      type:'Retur',
      date:head.return_date,
      barn_id:head.barn_id,
      assignment_id:head.contract_assignment_id||'',
      shipping_note_number:'',
      reference:head.reference||'',
      item_id:item.id,
      item_code:item.code,
      item_name:item.name,
      category:item.category,
      quantity:x.quantity,
      quantity_kg:x.quantity_kg,
      unit_price:x.unit_price,
      total_value:(x.unit_price==null?null:Number(x.quantity||0)*Number(x.unit_price||0)),
      unit:item.unit,
      notes:head.notes||'',
      supplier_name:''
    }:null;
  }).filter(Boolean);

  const externalRows=externalItems.map(x=>{
    const head=externalHeaders.find(h=>h.id===x.external_shipment_id);
    const item=itemsAll.find(i=>i.id===x.item_id);
    const supplier=supplierRows.find(s=>s.id===head?.supplier_id);
    return head&&item?{
      type:'Sapronak Luar',
      date:head.shipment_date,
      barn_id:head.barn_id,
      assignment_id:head.contract_assignment_id||'',
      shipping_note_number:'',
      reference:head.reference_number||'',
      item_id:item.id,
      item_code:item.code,
      item_name:item.name,
      category:item.category,
      quantity:x.quantity,
      quantity_kg:x.quantity_kg,
      unit_price:x.purchase_unit_price,
      total_value:Number(x.quantity||0)*Number(x.purchase_unit_price||0),
      unit:item.unit,
      notes:head.notes||'',
      supplier_name:supplier?.name||''
    }:null;
  }).filter(Boolean);

  const externalReturnRows=externalReturnItems.map(x=>{
    const head=externalReturns.find(r=>r.id===x.external_return_id);
    const item=itemsAll.find(i=>i.id===x.item_id);
    const source=externalItems.find(i=>i.id===x.external_shipment_item_id);
    const supplier=supplierRows.find(s=>s.id===head?.supplier_id);
    const qtyKg=item?.category==='PAKAN'?Number(x.quantity||0)*Number(item?.kg_per_unit||0):null;
    const unitPrice=source?.purchase_unit_price??null;
    return head&&item?{
      type:'Retur Sapronak Luar',date:head.return_date,barn_id:head.barn_id,assignment_id:head.contract_assignment_id||'',target_barn_id:'',
      shipping_note_number:'',reference:head.reference||'',item_id:item.id,item_code:item.code,item_name:item.name,
      category:item.category,quantity:x.quantity,quantity_kg:qtyKg,unit_price:unitPrice,
      total_value:(unitPrice==null?null:Number(x.quantity||0)*Number(unitPrice||0)),unit:item.unit,
      notes:head.notes||'',supplier_name:supplier?.name||'',status:head.status||'DRAFT'
    }:null;
  }).filter(Boolean);

  const externalTransferRows=externalTransfers.map(t=>{
    const ri=externalReturnItems.find(x=>x.id===t.external_return_item_id);
    const erow=externalReturns.find(x=>x.id===ri?.external_return_id);
    const item=itemsAll.find(i=>i.id===t.item_id);
    const supplier=supplierRows.find(s=>s.id===erow?.supplier_id);
    const qtyKg=item?.category==='PAKAN'?Number(t.quantity||0)*Number(item?.kg_per_unit||0):null;
    return item?{
      type:'Transfer Retur',date:t.transferred_on,barn_id:t.source_barn_id,assignment_id:erow?.contract_assignment_id||'',target_barn_id:t.target_barn_id,
      shipping_note_number:'',reference:'',item_id:item.id,item_code:item.code,item_name:item.name,
      category:item.category,quantity:t.quantity,quantity_kg:qtyKg,unit_price:null,total_value:null,unit:item.unit,
      notes:t.notes||'',supplier_name:supplier?.name||'',status:'TERKIRIM'
    }:null;
  }).filter(Boolean);

  const allRows=[...shipmentRows,...returnRows,...externalRows,...externalReturnRows,...externalTransferRows].sort((a,b)=>(b.date||'').localeCompare(a.date||''));

  let html='<section class="panel"><h3>Laporan Logistik</h3>'+
    '<form id="logisticsReportFilter" class="form-vertical">'+
      '<label>Tanggal Awal<input type="date" name="date_from"></label>'+
      '<label>Tanggal Akhir<input type="date" name="date_to"></label>'+
      '<label>Cari / Pilih Kandang<input id="reportBarnSearch" autocomplete="off" placeholder="Kosong = Semua Kandang"></label>'+
      '<input type="hidden" name="barn_id" id="reportBarnId">'+
      '<div id="reportBarnSuggestions" class="search-suggestions"></div>'+
      '<button type="button" id="reportAllBarns">Semua Kandang</button>'+
      '<label>Siklus<select name="assignment_id" id="logisticsReportCycle" disabled><option value="">Semua Siklus</option></select></label>'+
      '<label>Jenis Transaksi<select name="txn_type">'+
        '<option value="">Semua</option><option value="PENGIRIMAN">Pengiriman</option><option value="SAPRONAK_LUAR">Sapronak Luar</option><option value="RETUR_RHPP">Retur RHPP</option><option value="RETUR_LUAR">Retur Sapronak Luar</option><option value="TRANSFER_RETUR">Transfer Retur</option>'+
      '</select></label>'+
      '<label>Kategori Sapronak<select name="category">'+
        '<option value="">Semua</option><option value="DOC">DOC</option><option value="PAKAN">Pakan</option><option value="OVK">OVK</option><option value="LAINNYA">Lainnya</option>'+
      '</select></label>'+
      '<button type="submit">Tampilkan</button>'+
    '</form></section>'+
    '<section class="panel" id="logisticsReportOutput" style="display:none"><div id="logisticsReportSummary"></div>'+
      '<div class="report-actions">'+
        '<button type="button" id="logisticsPrint">Cetak</button> '+
        '<button type="button" id="logisticsPdf">PDF</button> '+
        '<button type="button" id="logisticsExcel">Excel</button>'+
      '</div>'+
      '<div id="logisticsReportSections"></div>'+

      '<p id="logisticsReportEmpty" class="muted">Atur filter lalu tekan Tampilkan.</p>'+
    '</section>';

  layout(html);

  const reportBarnSearch=document.getElementById('reportBarnSearch');
  const reportBarnId=document.getElementById('reportBarnId');
  const reportBarnSuggestions=document.getElementById('reportBarnSuggestions');
  const reportAllBarns=document.getElementById('reportAllBarns');
  const logisticsReportCycle=document.getElementById('logisticsReportCycle');
  const syncLogisticsReportCycles=()=>{
    const bid=reportBarnId?.value||'';
    const rows=bid?assignments.filter(a=>a.barn_id===bid):[];
    if(logisticsReportCycle){
      logisticsReportCycle.disabled=!bid;
      logisticsReportCycle.innerHTML='<option value="">Semua Siklus</option>'+rows.map(a=>'<option value="'+esc(a.id)+'">'+esc(assignmentCycleLabel(assignments,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED'))+'</option>').join('');
    }
  };
  const renderReportBarnSuggestions=()=>{
    const q=(reportBarnSearch.value||'').trim().toLowerCase();
    reportBarnId.value='';
    syncLogisticsReportCycles();
    const rows=q?barns.filter(x=>{
      const hay=[x.code,x.name,x.location,x.kind].filter(Boolean).join(' ').toLowerCase();
      return hay.includes(q);
    }).slice(0,5):[];
    reportBarnSuggestions.innerHTML=rows.map(x=>'<button type="button" class="search-suggestion" data-barn-id="'+esc(x.id)+'"><strong>'+esc(x.code+' · '+x.name)+'</strong><br><small>'+esc([x.location,x.kind].filter(Boolean).join(' · '))+'</small></button>').join('');
    if(q&&!rows.length)reportBarnSuggestions.innerHTML='<div class="search-empty">Kandang tidak ditemukan.</div>';
    reportBarnSuggestions.querySelectorAll('[data-barn-id]').forEach(btn=>btn.onclick=()=>{
      const b=barns.find(x=>x.id===btn.dataset.barnId);
      if(!b)return;
      reportBarnSearch.value=shortBarnLabel(b);
      reportBarnId.value=b.id;
      reportBarnSuggestions.innerHTML='';
      syncLogisticsReportCycles();
    });
  };
  reportBarnSearch.oninput=renderReportBarnSuggestions;
  reportBarnSearch.onfocus=renderReportBarnSuggestions;
  reportAllBarns.onclick=()=>{
    reportBarnSearch.value='';
    reportBarnId.value='';
    reportBarnSuggestions.innerHTML='';
    syncLogisticsReportCycles();
  };

  const err=br.error||ir.error||sr.error||sir.error||rr.error||rir.error||er.error||eir.error||exr.error||erir.error||etr.error||supr.error||ar.error||kr.error||cpr.error;
  if(err)msg(err.message);

  let filtered=[];

  const renderRows=()=>{
    const output=document.getElementById('logisticsReportOutput');
    if(output)output.style.display='';
    const form=document.getElementById('logisticsReportFilter');
    const fd=new FormData(form);
    const from=String(fd.get('date_from')||'');
    const to=String(fd.get('date_to')||'');
    const barnId=String(fd.get('barn_id')||'');
    const assignmentId=String(fd.get('assignment_id')||'');
    const txnType=String(fd.get('txn_type')||'');
    const category=String(fd.get('category')||'');

    const txnMatch=x=>!txnType||
      (txnType==='PENGIRIMAN'&&x.type==='Pengiriman')||
      (txnType==='SAPRONAK_LUAR'&&x.type==='Sapronak Luar')||
      (txnType==='RETUR_RHPP'&&x.type==='Retur')||
      (txnType==='RETUR_LUAR'&&x.type==='Retur Sapronak Luar')||
      (txnType==='TRANSFER_RETUR'&&x.type==='Transfer Retur');
    const categoryMatch=x=>!category||(category==='LAINNYA'?!['DOC','PAKAN','OVK'].includes(x.category):x.category===category);

    filtered=allRows.filter(x=>
      (!from||x.date>=from)&&
      (!to||x.date<=to)&&
      (!barnId||(x.barn_id===barnId||x.target_barn_id===barnId))&&
      (!assignmentId||x.assignment_id===assignmentId)&&
      txnMatch(x)&&categoryMatch(x)
    );

    const renderTable=(titleText,rows)=>{
      if(!rows.length)return '';
      const rowHtml=rows.map(x=>{
        const barn=barns.find(b=>b.id===x.barn_id);
        const assignment=assignments.find(a=>a.id===x.assignment_id);
        return '<tr>'+
          '<td>'+esc(x.date||'-')+'</td>'+
          '<td>'+esc(assignment?assignmentIdentity(assignments,barns,contractsRows,assignment):(barn?shortBarnLabel(barn):'-'))+'</td>'+
          '<td>'+esc(x.target_barn_id?(shortBarnLabel(barns.find(b=>b.id===x.target_barn_id))||'-'):'-')+'</td>'+
          '<td>'+esc(x.type)+'</td>'+
          '<td>'+esc(x.category||'-')+'</td>'+
          '<td>'+esc(x.item_code||'-')+'</td>'+
          '<td>'+esc(x.item_name||'-')+'</td>'+
          '<td>'+esc(x.supplier_name||'-')+'</td>'+
          '<td>'+fmtNumber(x.quantity)+'</td>'+
          '<td>'+esc(x.unit||'-')+'</td>'+
          '<td>'+fmtNumber(x.quantity_kg)+'</td>'+
          '<td>'+fmtNumber(x.unit_price)+'</td>'+
          '<td>'+fmtNumber(x.total_value)+'</td>'+
          '<td>'+esc(x.shipping_note_number||'-')+'</td>'+
          '<td>'+esc(x.reference||'-')+'</td>'+
          '<td>'+esc(x.status||'-')+'</td>'+
        '</tr>';
      }).join('');
      const qty=rows.reduce((n,x)=>n+Number(x.quantity||0),0);
      const kg=rows.reduce((n,x)=>n+Number(x.quantity_kg||0),0);
      const value=rows.reduce((n,x)=>n+Number(x.total_value||0),0);
      const unit=[...new Set(rows.map(x=>x.unit).filter(Boolean))].join(' / ');
      return '<section class="report-section-block">'+
        '<h3>'+esc(titleText)+'</h3>'+
        '<div class="tablewrap"><table class="logisticsReportTable">'+
          '<thead><tr><th>Tanggal</th><th>Kandang Asal</th><th>Kandang Tujuan</th><th>Jenis</th><th>Kategori</th><th>Kode</th><th>Sapronak</th><th>Supplier</th><th>Jumlah</th><th>Satuan</th><th>Kg</th><th>Harga/Satuan</th><th>Total</th><th>No. SJ Kiriman</th><th>Referensi</th><th>Status</th></tr></thead>'+
          '<tbody>'+rowHtml+'</tbody>'+
        '</table></div>'+
      '</section>';
    };

    const sections=document.getElementById('logisticsReportSections');
    if(txnType||category){
      const txLabel={PENGIRIMAN:'PENGIRIMAN',SAPRONAK_LUAR:'SAPRONAK LUAR',RETUR_RHPP:'RETUR RHPP',RETUR_LUAR:'RETUR SAPRONAK LUAR',TRANSFER_RETUR:'TRANSFER RETUR'}[txnType]||'';
      const titleParts=[txLabel,category].filter(Boolean);
      sections.innerHTML=renderTable(titleParts.join(' · ')||'HASIL',filtered);
    }else{
      sections.innerHTML=
        renderTable('PENGIRIMAN',filtered.filter(x=>x.type==='Pengiriman'))+
        renderTable('SAPRONAK LUAR',filtered.filter(x=>x.type==='Sapronak Luar'))+
        renderTable('RETUR RHPP',filtered.filter(x=>x.type==='Retur'))+
        renderTable('RETUR SAPRONAK LUAR',filtered.filter(x=>x.type==='Retur Sapronak Luar'))+
        renderTable('TRANSFER RETUR',filtered.filter(x=>x.type==='Transfer Retur'));
    }

    document.getElementById('logisticsReportEmpty').textContent=filtered.length?'':'Tidak ada data sesuai filter.';
    const shipRows=filtered.filter(x=>x.type==='Pengiriman');
    const extRows=filtered.filter(x=>x.type==='Sapronak Luar');
    const extRetRows=filtered.filter(x=>x.type==='Retur Sapronak Luar');
    const transferRows=filtered.filter(x=>x.type==='Transfer Retur');
    const retRows=filtered.filter(x=>x.type==='Retur');
    const totalShipRows=shipRows.length;
    const totalReturnRows=retRows.length;
    const totalShipValue=shipRows.reduce((n,x)=>n+Number(x.total_value||0),0);
    const totalReturnValue=retRows.reduce((n,x)=>n+Number(x.total_value||0),0);
    const grandTotal=totalShipValue-totalReturnValue;

    const docRows=shipRows.filter(x=>x.category==='DOC');
    const feedRows=shipRows.filter(x=>x.category==='PAKAN');
    const ovkRows=shipRows.filter(x=>x.category==='OVK');

    const docQty=docRows.reduce((n,x)=>n+Number(x.quantity||0),0);
    const docValue=docRows.reduce((n,x)=>n+Number(x.total_value||0),0);
    const feedQty=feedRows.reduce((n,x)=>n+Number(x.quantity||0),0);
    const feedKg=feedRows.reduce((n,x)=>n+Number(x.quantity_kg||0),0);
    const feedValue=feedRows.reduce((n,x)=>n+Number(x.total_value||0),0);
    const ovkQty=ovkRows.reduce((n,x)=>n+Number(x.quantity||0),0);
    const ovkKg=ovkRows.reduce((n,x)=>n+Number(x.quantity_kg||0),0);
    const ovkValue=ovkRows.reduce((n,x)=>n+Number(x.total_value||0),0);
    const returnQty=retRows.reduce((n,x)=>n+Number(x.quantity||0),0);
    const returnKg=retRows.reduce((n,x)=>n+Number(x.quantity_kg||0),0);
    const shipKg=shipRows.reduce((n,x)=>n+Number(x.quantity_kg||0),0);
    const netKg=shipKg-returnKg;

    document.getElementById('logisticsReportSummary').innerHTML=
      '<p><strong>'+filtered.length+'</strong> baris · Pengiriman: <strong>'+totalShipRows+'</strong> · Sapronak Luar: <strong>'+extRows.length+'</strong> · Retur RHPP: <strong>'+totalReturnRows+'</strong> · Retur Sapronak Luar: <strong>'+extRetRows.length+'</strong> · Transfer Retur: <strong>'+transferRows.length+'</strong></p>';


  };

  document.getElementById('logisticsReportFilter').onsubmit=e=>{e.preventDefault();renderRows();};

  const reportHtml=()=>{
    const rows=document.getElementById('logisticsReportSections')?.innerHTML||'';
    const fd=new FormData(document.getElementById('logisticsReportFilter'));
    const from=fd.get('date_from')||'-', to=fd.get('date_to')||'-';
    const barnId=fd.get('barn_id')||'';
    const barn=barns.find(b=>b.id===barnId);
    const txnType=fd.get('txn_type')||'Semua';
    const category=fd.get('category')||'Semua';
    return '<!doctype html><html><head><meta charset="utf-8"><title>Laporan Logistik</title>'+
      '<style>@page{size:A4 landscape;margin:5mm}html,body{margin:0;padding:0;font-family:Arial,sans-serif;font-size:9px;line-height:1.15}h2{margin:0 0 3px;font-size:13px}h3{margin:4px 0 2px;font-size:10px}p{margin:2px 0 4px}table{width:100%;border-collapse:collapse;font-size:8.5px;table-layout:auto}th,td{border:1px solid #999;padding:2px 3px;text-align:left;white-space:nowrap}th{font-weight:700}thead{display:table-header-group}tr{break-inside:avoid;page-break-inside:avoid}.report-section-block{margin-bottom:3px}.report-section-block h3{margin:2px 0 1px}.print-letterhead{display:flex;align-items:center;gap:8px;border-bottom:1.5px solid #222;padding-bottom:3px;margin-bottom:3px}.print-letterhead img{width:50px!important;height:50px!important}.print-letterhead h2{font-size:12px!important}.print-letterhead div{line-height:1.08}@media print{button{display:none}}</style>'+
      '</head><body>'+
      '<div class="print-letterhead">'+
        '<img src="'+BMS_PRINT_LOGO+'" style="object-fit:contain">'+
        '<div><h2 style="margin:0">'+esc(company.company_name||company.legal_name||'Laporan Logistik')+'</h2>'+
        '<div style="white-space:pre-line">'+esc(company.address||'')+'</div>'+
        (company.phone?'<div>Tel/WA: '+esc(company.phone)+'</div>':'')+
        (company.email?'<div>'+esc(company.email)+'</div>':'')+
        '</div></div>'+
      '<h2 style="margin:0 0 4px">Laporan Logistik</h2>'+
      '<p>Periode: '+esc(String(from))+' s/d '+esc(String(to))+' · Kandang: '+esc(barn?shortBarnLabel(barn):'Semua Kandang')+' · Transaksi: '+esc(String(txnType))+' · Kategori: '+esc(String(category))+'</p>'+
      rows+'</body></html>';
  };

  const printWhenReady=(w)=>{
    const imgs=[...w.document.images];
    const doPrint=()=>{w.focus();setTimeout(()=>w.print(),150);};
    if(!imgs.length)return doPrint();
    let left=imgs.length,done=false;
    const finish=()=>{if(done)return;if(--left<=0){done=true;doPrint();}};
    imgs.forEach(img=>{
      if(img.complete)finish();
      else{img.onload=finish;img.onerror=finish;}
    });
    setTimeout(()=>{if(!done){done=true;doPrint();}},2500);
  };

  document.getElementById('logisticsPrint').onclick=()=>{
    renderRows();
    const w=window.open('','_blank');
    if(!w)return msg('Popup cetak diblokir browser.');
    w.document.write(reportHtml());
    w.document.close();
    printWhenReady(w);
  };

  document.getElementById('logisticsPdf').onclick=()=>{
    renderRows();
    const w=window.open('','_blank');
    if(!w)return msg('Popup PDF diblokir browser.');
    w.document.write(reportHtml().replace('<title>Laporan Logistik</title>','<title>Laporan_Logistik_PDF</title>'));
    w.document.close();
    printWhenReady(w);
  };

  document.getElementById('logisticsExcel').onclick=()=>{
    renderRows();
    const tables=document.getElementById('logisticsReportSections')?.innerHTML||'';
    const blob=new Blob(['\ufeff<html><head><meta charset="utf-8"></head><body>'+tables+'</body></html>'],{type:'application/vnd.ms-excel;charset=utf-8'});
    const url=URL.createObjectURL(blob);
    const a=document.createElement('a');
    a.href=url;
    a.download='Laporan_Logistik.xls';
    document.body.appendChild(a);
    a.click();
    a.remove();
    setTimeout(()=>URL.revokeObjectURL(url),1000);
  };
}

async function reports(){
  const [ar,br,cr,rr,hr,bopr,rhppr,bal]=await Promise.all([
    db.from('logistics_contract_assignments').select('id,barn_id,master_contract_id,start_date,active').order('start_date',{ascending:false}),
    db.from('barns').select('id,code,name'),
    db.from('contracts').select('id,number').is('cycle_id',null),
    db.from('recordings').select('contract_assignment_id,age_days,mortality,culling,feed_kg,avg_weight_kg').not('contract_assignment_id','is',null),
    db.from('marketing_contract_harvests').select('contract_assignment_id,birds,net_weight_kg,total_amount'),
    db.from('bop').select('contract_assignment_id,amount'),
    db.from('rhpp_real').select('contract_assignment_id,amount'),
    db.from('advance_balances').select('*')
  ]);
  const err=[ar,br,cr,rr,hr,bopr,rhppr,bal].find(x=>x.error)?.error;
  const ars=ar.data||[],bs=br.data||[],cs=cr.data||[],recs=rr.data||[],hs=hr.data||[],bops=bopr.data||[],rhpps=rhppr.data||[],balances=bal.data||[];
  window.__productionReportState=window.__productionReportState||{barn:'',assignment:''};
  const st=window.__productionReportState;
  const cycleRows=st.barn?ars.filter(a=>a.barn_id===st.barn):[];
  const visibleAssignments=ars.filter(a=>(!st.barn||a.barn_id===st.barn)&&(!st.assignment||a.id===st.assignment));
  const rows=visibleAssignments.map(a=>{
    const b=bs.find(x=>x.id===a.barn_id),k=cs.find(x=>x.id===a.master_contract_id);
    const rs=recs.filter(x=>x.contract_assignment_id===a.id),hh=hs.filter(x=>x.contract_assignment_id===a.id);
    const mortality=rs.reduce((n,x)=>n+prodNum(x.mortality)+prodNum(x.culling),0);
    const feed=rs.reduce((n,x)=>n+prodNum(x.feed_kg),0);
    const birds=hh.reduce((n,x)=>n+prodNum(x.birds),0);
    const kg=hh.reduce((n,x)=>n+prodNum(x.net_weight_kg),0);
    const bop=bops.filter(x=>x.contract_assignment_id===a.id).reduce((n,x)=>n+prodNum(x.amount),0);
    const rhpp=rhpps.find(x=>x.contract_assignment_id===a.id);
    return '<tr><td>'+esc(assignmentIdentity(ars,bs,cs,a))+'</td><td>'+esc(shortContractLabel(k?.number)||'-')+'</td><td>'+(a.active?'AKTIF':'CLOSED')+'</td><td>'+prodFmt(mortality,0)+'</td><td>'+prodFmt(feed,2)+'</td><td>'+prodFmt(birds,0)+'</td><td>'+prodFmt(kg,2)+'</td><td>'+prodFmt(rhpp?.amount||0,2)+'</td><td>'+prodFmt(bop,2)+'</td></tr>';
  }).join('');
  layout('<section class="panel"><h3>Filter Laporan Produksi</h3><form id="productionReportFilter" class="form-vertical">'+
    '<label>Kandang<select name="barn"><option value="">Semua Kandang</option>'+bs.map(b=>'<option value="'+esc(b.id)+'" '+(st.barn===b.id?'selected':'')+'>'+esc(shortBarnLabel(b))+'</option>').join('')+'</select></label>'+
    '<label>Siklus<select name="assignment" '+(!st.barn?'disabled':'')+'><option value="">Semua Siklus</option>'+cycleRows.map(a=>'<option value="'+esc(a.id)+'" '+(st.assignment===a.id?'selected':'')+'>'+esc(assignmentCycleLabel(ars,a)+' · '+prodDateId(a.start_date)+' · '+(a.active?'AKTIF':'CLOSED'))+'</option>').join('')+'</select></label>'+
    '<button type="submit">Tampilkan</button></form></section>'+
    '<section class="panel" id="productionReportPrintArea"><div class="rhpp-section-head"><div><h3>Rekap per Kontrak Logistik</h3></div><div class="report-actions"><button type="button" id="productionReportPrint">Cetak / PDF</button></div></div><div class="tablewrap"><table><thead><tr><th>Kandang / Siklus / Kontrak</th><th>Kontrak</th><th>Status</th><th>Deplesi Ekor</th><th>Pakan Kg</th><th>Panen Ekor</th><th>Panen Kg</th><th>RHPP</th><th>BOP</th></tr></thead><tbody>'+rows+'</tbody></table></div></section>'+
    (['ADMIN','OWNER','KEUANGAN'].includes(profile.role)?'<section class="panel"><h3>Sisa Kasbon Karyawan</h3><div class="tablewrap"><table><tr><th>ID</th><th>Nominal</th><th>Dibayar</th><th>Sisa</th></tr>'+balances.map(x=>'<tr><td>'+esc(x.id)+'</td><td>'+fmtNumber(x.amount)+'</td><td>'+fmtNumber(x.paid)+'</td><td>'+fmtNumber(x.balance)+'</td></tr>').join('')+'</table></div></section>':''));
  const productionReportPrint=document.getElementById('productionReportPrint');if(productionReportPrint)productionReportPrint.onclick=()=>printFinanceDocument('productionReportPrintArea','Laporan Produksi');
  const reportFilter=document.getElementById('productionReportFilter');
  if(reportFilter){
    const barnSel=reportFilter.elements.barn;
    barnSel.onchange=async()=>{st.barn=barnSel.value||'';st.assignment='';await reports();};
    reportFilter.onsubmit=async e=>{e.preventDefault();const fd=new FormData(reportFilter);st.barn=String(fd.get('barn')||'');st.assignment=st.barn?String(fd.get('assignment')||''):'';await reports();};
  }
  if(err)msg(err.message);
}

start();
