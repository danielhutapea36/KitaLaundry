const fs = require("fs")
const path = require("path")

const file = path.join(__dirname, "src/app/customer/orders/new/page.tsx")
let content = fs.readFileSync(file, "utf8")

content = content.replace(
  "const [selectedService, setSelectedService] = useState('wash_fold')",
  "const [selectedServices, setSelectedServices] = useState<string[]>(['wash_fold'])"
)

content = content.replace(
  "service: selectedService,",
  "service: selectedServices[0],"
)

content = content.replace(
  "const getCurrentItemTypes = () => {\n    return serviceItems[selectedService] || []\n  }",
  `const getCurrentItemTypes = () => {
    let allItems: any[] = []
    selectedServices.forEach(srv => {
      if (serviceItems[srv]) {
        allItems = [...allItems, ...serviceItems[srv]]
      }
    })
    return allItems
  }`
)

content = content.replace(
  "service: selectedService,",
  "service: selectedServices[0],"
)

content = content.replace(
  "return selectedService !== ''",
  "return selectedServices.length > 0"
)

content = content.replace(
  /selectedService === service\.code\n\s*\?\ 'border-teal-500 bg-teal-50'/g,
  "selectedServices.includes(service.code)\n                            ? 'border-teal-500 bg-teal-50'"
)

content = content.replace(
  /onClick=\{\(\) => \{\n\s*setSelectedService\(service\.code\)\n\s*setItems\(\{\}\)\n\s*\}\}/g,
  `onClick={() => {
                          if (selectedServices.includes(service.code)) {
                            setSelectedServices(selectedServices.filter(s => s !== service.code))
                          } else {
                            setSelectedServices([...selectedServices, service.code])
                          }
                        }}`
)

content = content.replace(
  /selectedService === service\.code \? 'border-teal-500 bg-teal-500' : 'border-slate-300'/g,
  "selectedServices.includes(service.code) ? 'border-teal-500 bg-teal-500' : 'border-slate-300'"
)

content = content.replace(
  /\{selectedService === service\.code && \(\n\s*<div className=\"w-2 h-2 rounded-full bg-white\" \/>\n\s*\)\}/g,
  `{selectedServices.includes(service.code) && (
                              <Check className="w-4 h-4 text-white" />
                            )}`
)

content = content.replace(
  /className=\{(.*?)\}w-6 h-6 rounded-full border(.*?)\}/g,
  "className={$1w-6 h-6 rounded border$2}"
)

content = content.replace(
  /\{branchServices\.find\(s => s\.code === selectedService\)\?\.displayName \|\| selectedService\}/g,
  "{selectedServices.map(srv => branchServices.find(s => s.code === srv)?.displayName || srv).join(', ')}"
)

fs.writeFileSync(file, content)
