CHART_NAME := veecode-devportal-chart
CHART_DIR := $(CHART_NAME)
CHART_PACKAGE := $(CHART_NAME)-*.tgz
CHARTS_DIR := docs

.PHONY: all deps package index publish clean release

all: index

release:
	./update_version.sh
	@echo "RELEASE: package + index"
	$(MAKE) index

deps:
	cd $(CHART_DIR) && helm dependency update

package: deps
	helm package $(CHART_DIR) --destination $(CHARTS_DIR)

index: package
	helm repo index $(CHARTS_DIR) --url https://veecode-platform.github.io/next-charts

clean:
	rm -f $(CHARTS_DIR)/*.tgz
	rm -f $(CHARTS_DIR)/index.yaml
