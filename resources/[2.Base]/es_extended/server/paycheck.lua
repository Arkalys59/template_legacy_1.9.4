function StartPayCheck()
  CreateThread(function()
    while true do
      Wait(Config.PaycheckInterval)

      for player, xPlayer in pairs(ESX.Players) do
        local job = xPlayer.job.grade_name
        local salary = xPlayer.job.grade_salary

        if salary > 0 then
          if job == 'unemployed' then -- unemployed
            xPlayer.addAccountMoney('bank', salary, "Welfare Check")
            TriggerClientEvent('ox_lib:notify', player, {title = TranslateCap('received_paycheck'), description = TranslateCap('received_help', salary), type = 'inform'})
          elseif Config.EnableSocietyPayouts then -- possibly a society
            TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(society)
              if society ~= nil then -- verified society
                TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                  if account.money >= salary then -- does the society money to pay its employees?
                    xPlayer.addAccountMoney('bank', salary, "Paycheck")
                    account.removeMoney(salary)

                    TriggerClientEvent('ox_lib:notify', player, {title = TranslateCap('received_paycheck'), description = TranslateCap('received_salary', salary), type = 'inform'})
                  else
                    TriggerClientEvent('ox_lib:notify', player, {title = TranslateCap('bank'), description = TranslateCap('company_nomoney', salary), type = 'inform'})
                  end
                end)
              else -- not a society
                xPlayer.addAccountMoney('bank', salary, "Paycheck")
                TriggerClientEvent('ox_lib:notify', player, {title = TranslateCap('received_paycheck'), description = TranslateCap('received_salary', salary), type = 'inform'})
              end
            end)
          else -- generic job
            xPlayer.addAccountMoney('bank', salary, "Paycheck")
            TriggerClientEvent('ox_lib:notify', player, {title = TranslateCap('received_paycheck'), description = TranslateCap('received_salary', salary), type = 'inform'})
          end
        end
      end
    end
  end)
end
