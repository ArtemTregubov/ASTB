
&НаКлиенте
Процедура Отправить(Команда)
	
	ОтправитьУведомлениеНаСервере();
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЭтуФорму(Команда)
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьУведомлениеНаСервере()
	
	Уведомление 		= Новый ДоставляемоеУведомление;
	Уведомление.Данные 	= "ПроизвольноеУведомление";
	Уведомление.Текст 	= ТекстУведомления;
	
	ОтправкаPUSHВызовСервера.ОтправитьУведомление(Уведомление,Параметры.ФизическоеЛицо, Перечисления.ВидыУведомлений.Произвольное);	
	
КонецПроцедуры	